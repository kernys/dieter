import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/weight_log_model.dart';
import '../../../../services/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Time range filter
enum TimeRange { days90, months6, year1, all }

final timeRangeProvider = StateProvider<TimeRange>((ref) {
  return TimeRange.months6;
});

// Convert TimeRange to API range string
String _getApiRange(TimeRange range) {
  switch (range) {
    case TimeRange.days90:
      return '90d';
    case TimeRange.months6:
      return '6m';
    case TimeRange.year1:
      return '1y';
    case TimeRange.all:
      return 'all';
  }
}

// Weight logs response provider - fetches from API
final weightLogsResponseProvider = FutureProvider<WeightLogsResponse?>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authStateProvider);
  final timeRange = ref.watch(timeRangeProvider);

  final userId = authState.userId;
  if (userId == null) {
    return null;
  }

  try {
    return await apiService.getWeightLogs(range: _getApiRange(timeRange));
  } catch (e) {
    return null;
  }
});

// Weight logs provider
final weightLogsProvider = FutureProvider<List<WeightLogModel>>((ref) async {
  final response = await ref.watch(weightLogsResponseProvider.future);
  return response?.logs ?? [];
});

// Current weight provider
final currentWeightProvider = Provider<double>((ref) {
  final response = ref.watch(weightLogsResponseProvider);
  return response.when(
    data: (data) => data?.stats.currentWeight ?? 0.0,
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

// Goal weight provider - fetched from user settings
final goalWeightProvider = Provider<double>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user?.goalWeight ?? 140.0;
});

// Progress percentage provider
// Shows progress towards goal weight based on distance from goal
// 100% = at goal, lower % = further from goal
// Works for both weight loss AND weight gain goals
final progressPercentageProvider = Provider<double>((ref) {
  final response = ref.watch(weightLogsResponseProvider);

  return response.when(
    data: (data) {
      if (data == null) return 0;

      final goal = ref.watch(goalWeightProvider);
      final currentWeight = data.stats.currentWeight;

      if (goal == 0 || currentWeight == 0) return 0;

      // If at goal, return 100%
      final distanceFromGoal = (currentWeight - goal).abs();
      if (distanceFromGoal < 0.1) return 100;

      // Calculate progress based on how close current weight is to goal
      // Using a reasonable range (e.g., 50 units from goal = 0%)
      // Example: goal=70kg, current=70kg -> 100%
      //          goal=70kg, current=60kg -> distance=10, progress depends on how we scale
      //          goal=70kg, current=80kg -> distance=10, same logic
      
      // Use a scale where being within reasonable range shows meaningful progress
      // Max distance for 0% is dynamically calculated based on goal
      final maxReasonableDistance = goal * 0.3; // 30% of goal weight as max distance
      
      if (maxReasonableDistance == 0) return 100;
      
      // Progress = 100% when at goal, decreases as distance increases
      final progress = ((1 - (distanceFromGoal / maxReasonableDistance)) * 100).clamp(0.0, 100.0);
      
      return progress;
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

// Streak data provider - fetches from API
final streakDataProvider = FutureProvider<StreakData>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authStateProvider);

  final userId = authState.userId;
  if (userId == null) {
    return StreakData(currentStreak: 0, weekData: List.filled(7, false));
  }

  try {
    final response = await apiService.getStreak();
    return StreakData(
      currentStreak: response.currentStreak,
      weekData: response.weekData,
    );
  } catch (e) {
    return StreakData(currentStreak: 0, weekData: List.filled(7, false));
  }
});

// Weekly energy data provider
final weeklyEnergyDataProvider = FutureProvider<WeeklyEnergyData>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authStateProvider);

  final userId = authState.userId;
  if (userId == null) {
    return WeeklyEnergyData.empty();
  }

  try {
    final now = DateTime.now();
    // Get Sunday of current week
    final sunday = now.subtract(Duration(days: now.weekday % 7));

    final List<int> consumedData = [];
    final List<int> burnedData = [];
    int totalConsumed = 0;
    int totalBurned = 0;

    for (int i = 0; i < 7; i++) {
      final date = sunday.add(Duration(days: i));
      
      // Get consumed calories from food entries
      try {
        final response = await apiService.getFoodEntries(date);
        final dayCalories = response.summary.totalCalories;
        consumedData.add(dayCalories);
        totalConsumed += dayCalories;
      } catch (e) {
        consumedData.add(0);
      }
      
      // Get burned calories from exercise entries
      try {
        final exerciseResponse = await apiService.getExerciseEntries(date);
        final dayBurned = exerciseResponse.totalCaloriesBurned;
        burnedData.add(dayBurned);
        totalBurned += dayBurned;
      } catch (e) {
        burnedData.add(0);
      }
    }

    // Calculate daily average (only count days with data)
    final daysWithData = consumedData.where((c) => c > 0).length;
    final dailyAverage = daysWithData > 0 ? totalConsumed ~/ daysWithData : 0;

    return WeeklyEnergyData(
      consumedData: consumedData,
      burnedData: burnedData,
      totalConsumed: totalConsumed,
      totalBurned: totalBurned,
      dailyAverage: dailyAverage,
    );
  } catch (e) {
    return WeeklyEnergyData.empty();
  }
});

// Daily average calories provider
final dailyAverageCaloriesProvider = FutureProvider<DailyAverageData>((ref) async {
  final weeklyData = await ref.watch(weeklyEnergyDataProvider.future);

  return DailyAverageData(
    calories: weeklyData.dailyAverage,
    changePercentage: 0,
    isIncrease: false,
  );
});

// Add weight log action
final addWeightLogProvider = FutureProvider.family<WeightLogModel?, AddWeightLogParams>((ref, params) async {
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authStateProvider);

  final userId = authState.userId;
  if (userId == null) {
    throw Exception('User not authenticated');
  }

  // Check if user is in guest mode - cannot save to server
  if (authState.isGuestMode) {
    throw Exception('Please sign in to save weight logs');
  }

  try {
    final log = await apiService.createWeightLog(
      weight: params.weight,
      note: params.note,
    );

    // Invalidate weight logs to refresh
    ref.invalidate(weightLogsResponseProvider);

    return log;
  } catch (e) {
    rethrow;
  }
});

class StreakData {
  final int currentStreak;
  final List<bool> weekData;

  StreakData({
    required this.currentStreak,
    required this.weekData,
  });
}

class DailyAverageData {
  final int calories;
  final int changePercentage;
  final bool isIncrease;

  DailyAverageData({
    required this.calories,
    required this.changePercentage,
    required this.isIncrease,
  });
}

class AddWeightLogParams {
  final double weight;
  final String? note;

  AddWeightLogParams({
    required this.weight,
    this.note,
  });
}

class WeeklyEnergyData {
  final List<int> consumedData;
  final List<int> burnedData;
  final int totalConsumed;
  final int totalBurned;
  final int dailyAverage;

  WeeklyEnergyData({
    required this.consumedData,
    required this.burnedData,
    required this.totalConsumed,
    required this.totalBurned,
    required this.dailyAverage,
  });

  factory WeeklyEnergyData.empty() {
    return WeeklyEnergyData(
      consumedData: List.filled(7, 0),
      burnedData: List.filled(7, 0),
      totalConsumed: 0,
      totalBurned: 0,
      dailyAverage: 0,
    );
  }
}

// Weight change data class
class WeightChangeData {
  final double day3;
  final double day7;
  final double day14;
  final double day30;
  final double day90;
  final double allTime;

  WeightChangeData({
    required this.day3,
    required this.day7,
    required this.day14,
    required this.day30,
    required this.day90,
    required this.allTime,
  });

  factory WeightChangeData.empty() {
    return WeightChangeData(
      day3: 0,
      day7: 0,
      day14: 0,
      day30: 0,
      day90: 0,
      allTime: 0,
    );
  }
}

// Weight change provider - calculates weight changes for different periods
final weightChangeProvider = FutureProvider<WeightChangeData>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authStateProvider);

  final userId = authState.userId;
  if (userId == null) {
    return WeightChangeData.empty();
  }

  try {
    // Fetch all weight logs to calculate changes
    final response = await apiService.getWeightLogs(range: 'all');
    final logs = response.logs;

    if (logs.isEmpty) {
      return WeightChangeData.empty();
    }

    // Sort by date descending (most recent first)
    logs.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

    final currentWeight = logs.first.weight;
    final now = DateTime.now();

    // Helper function to find weight at a specific date or closest before
    double? findWeightAtDaysAgo(int daysAgo) {
      final targetDate = now.subtract(Duration(days: daysAgo));
      // Find the first log that is at or before the target date
      for (final log in logs) {
        if (log.loggedAt.isBefore(targetDate) ||
            log.loggedAt.day == targetDate.day &&
            log.loggedAt.month == targetDate.month &&
            log.loggedAt.year == targetDate.year) {
          return log.weight;
        }
      }
      return null;
    }

    // Calculate changes for each period
    final weight3d = findWeightAtDaysAgo(3);
    final weight7d = findWeightAtDaysAgo(7);
    final weight14d = findWeightAtDaysAgo(14);
    final weight30d = findWeightAtDaysAgo(30);
    final weight90d = findWeightAtDaysAgo(90);
    final weightStart = logs.last.weight; // Oldest weight

    return WeightChangeData(
      day3: weight3d != null ? currentWeight - weight3d : 0,
      day7: weight7d != null ? currentWeight - weight7d : 0,
      day14: weight14d != null ? currentWeight - weight14d : 0,
      day30: weight30d != null ? currentWeight - weight30d : 0,
      day90: weight90d != null ? currentWeight - weight90d : 0,
      allTime: currentWeight - weightStart,
    );
  } catch (e) {
    return WeightChangeData.empty();
  }
});
