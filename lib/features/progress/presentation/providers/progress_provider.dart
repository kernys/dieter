import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/weight_log_model.dart';

// Time range filter
enum TimeRange { days90, months6, year1, all }

final timeRangeProvider = StateProvider<TimeRange>((ref) {
  return TimeRange.months6;
});

// Weight logs provider
final weightLogsProvider = FutureProvider<List<WeightLogModel>>((ref) async {
  // TODO: Fetch from Supabase
  await Future.delayed(const Duration(milliseconds: 500));

  // Mock data
  final now = DateTime.now();
  return [
    WeightLogModel(
      id: '1',
      userId: 'user-1',
      weight: 132.1,
      loggedAt: now,
    ),
    WeightLogModel(
      id: '2',
      userId: 'user-1',
      weight: 131.2,
      loggedAt: now.subtract(const Duration(days: 7)),
    ),
    WeightLogModel(
      id: '3',
      userId: 'user-1',
      weight: 130.5,
      loggedAt: now.subtract(const Duration(days: 14)),
    ),
    WeightLogModel(
      id: '4',
      userId: 'user-1',
      weight: 129.8,
      loggedAt: now.subtract(const Duration(days: 30)),
    ),
    WeightLogModel(
      id: '5',
      userId: 'user-1',
      weight: 128.2,
      loggedAt: now.subtract(const Duration(days: 60)),
    ),
    WeightLogModel(
      id: '6',
      userId: 'user-1',
      weight: 125.5,
      loggedAt: now.subtract(const Duration(days: 90)),
    ),
    WeightLogModel(
      id: '7',
      userId: 'user-1',
      weight: 122.3,
      loggedAt: now.subtract(const Duration(days: 120)),
    ),
  ];
});

// Current weight provider
final currentWeightProvider = Provider<double>((ref) {
  final logs = ref.watch(weightLogsProvider);
  return logs.when(
    data: (data) => data.isNotEmpty ? data.first.weight : 0.0,
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

// Goal weight provider
final goalWeightProvider = StateProvider<double>((ref) {
  return 140.0;
});

// Progress percentage provider
final progressPercentageProvider = Provider<double>((ref) {
  final current = ref.watch(currentWeightProvider);
  final goal = ref.watch(goalWeightProvider);

  if (goal == 0) return 0;

  // Calculate progress based on starting weight assumption
  final startWeight = 120.0; // Assumed starting weight
  final totalToGain = goal - startWeight;
  final gained = current - startWeight;

  if (totalToGain <= 0) return 0;
  return (gained / totalToGain * 100).clamp(0, 100);
});

// Streak data provider
final streakDataProvider = Provider<StreakData>((ref) {
  return StreakData(
    currentStreak: 21,
    weekData: [true, true, false, false, false, false, false], // S M T W T F S
  );
});

// Daily average calories provider
final dailyAverageCaloriesProvider = Provider<DailyAverageData>((ref) {
  return DailyAverageData(
    calories: 2861,
    changePercentage: 90,
    isIncrease: true,
  );
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
