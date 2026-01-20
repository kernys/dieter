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
    return await apiService.getWeightLogs(userId, range: _getApiRange(timeRange));
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
final progressPercentageProvider = Provider<double>((ref) {
  final response = ref.watch(weightLogsResponseProvider);

  return response.when(
    data: (data) {
      if (data == null) return 0;

      final goal = ref.watch(goalWeightProvider);
      final startWeight = data.stats.startWeight;
      final currentWeight = data.stats.currentWeight;

      if (goal == 0) return 0;

      final totalToGain = goal - startWeight;
      final gained = currentWeight - startWeight;

      if (totalToGain <= 0) return 0;
      return (gained / totalToGain * 100).clamp(0, 100);
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
    final response = await apiService.getStreak(userId);
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
    int totalConsumed = 0;

    for (int i = 0; i < 7; i++) {
      final date = sunday.add(Duration(days: i));
      try {
        final response = await apiService.getFoodEntries(userId, date);
        final dayCalories = response.summary.totalCalories;
        consumedData.add(dayCalories);
        totalConsumed += dayCalories;
      } catch (e) {
        consumedData.add(0);
      }
    }

    // Calculate daily average (only count days with data)
    final daysWithData = consumedData.where((c) => c > 0).length;
    final dailyAverage = daysWithData > 0 ? totalConsumed ~/ daysWithData : 0;

    return WeeklyEnergyData(
      consumedData: consumedData,
      burnedData: List.filled(7, 0), // No burned data for now
      totalConsumed: totalConsumed,
      totalBurned: 0,
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
      userId: userId,
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
