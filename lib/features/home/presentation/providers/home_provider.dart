import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/food_entry_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../services/api_service.dart';
import '../../../../services/cache_service.dart';
import '../../../../services/health_service.dart';
import '../../../../services/live_activity_service.dart';
import '../../../../services/widget_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Selected date provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Daily summary provider - fetches from real API with cache-first strategy
final dailySummaryProvider = FutureProvider.family<DailySummaryModel, DateTime>((ref, date) async {
  final apiService = ref.watch(apiServiceProvider);
  final cacheService = ref.watch(cacheServiceProvider);
  final authState = ref.watch(authStateProvider);

  // Get user ID from auth state
  final userId = authState.userId;
  if (userId == null) {
    // Return empty summary if not authenticated
    return DailySummaryModel(
      id: 'empty',
      userId: '',
      date: date,
      totalCalories: 0,
      totalProtein: 0,
      totalCarbs: 0,
      totalFat: 0,
      entries: [],
    );
  }

  // Helper to build model from cache
  Future<DailySummaryModel?> getFromCache() async {
    final cachedEntries = await cacheService.getCachedFoodEntries(userId, date);
    final cachedSummary = await cacheService.getCachedDailySummary(userId, date);
    
    if (cachedEntries != null && cachedSummary != null) {
      return DailySummaryModel(
        id: 'cached-${date.toIso8601String()}',
        userId: userId,
        date: date,
        totalCalories: cachedSummary['totalCalories'] ?? 0,
        totalProtein: (cachedSummary['totalProtein'] as num?)?.toDouble() ?? 0.0,
        totalCarbs: (cachedSummary['totalCarbs'] as num?)?.toDouble() ?? 0.0,
        totalFat: (cachedSummary['totalFat'] as num?)?.toDouble() ?? 0.0,
        entries: cachedEntries,
      );
    }
    return null;
  }

  try {
    final response = await apiService.getFoodEntries(date);

    // Cache the data for offline use
    await cacheService.cacheFoodEntries(userId, date, response.entries);
    await cacheService.cacheDailySummary(userId, date, {
      'totalCalories': response.summary.totalCalories,
      'totalProtein': response.summary.totalProtein,
      'totalCarbs': response.summary.totalCarbs,
      'totalFat': response.summary.totalFat,
    });

    return DailySummaryModel(
      id: 'summary-${date.toIso8601String()}',
      userId: userId,
      date: date,
      totalCalories: response.summary.totalCalories,
      totalProtein: response.summary.totalProtein,
      totalCarbs: response.summary.totalCarbs,
      totalFat: response.summary.totalFat,
      entries: response.entries,
    );
  } catch (e) {
    // Try to load from cache on any error
    final cached = await getFromCache();
    if (cached != null) {
      return cached;
    }

    // Return empty summary if no cache available
    return DailySummaryModel(
      id: 'empty',
      userId: userId,
      date: date,
      totalCalories: 0,
      totalProtein: 0,
      totalCarbs: 0,
      totalFat: 0,
      entries: [],
    );
  }
});

// User goals provider - fetches from user settings with cache support
final userGoalsProvider = FutureProvider<UserGoals>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final cacheService = ref.watch(cacheServiceProvider);
  final authState = ref.watch(authStateProvider);

  final userId = authState.userId;
  if (userId == null) {
    return UserGoals(
      calorieGoal: AppConstants.defaultCalorieGoal,
      proteinGoal: AppConstants.defaultProteinGoal,
      carbsGoal: AppConstants.defaultCarbsGoal,
      fatGoal: AppConstants.defaultFatGoal,
    );
  }

  // Helper to build from cache
  Future<UserGoals?> getFromCache() async {
    final cached = await cacheService.getCachedUserGoals(userId);
    if (cached != null) {
      return UserGoals(
        calorieGoal: cached['calorieGoal'] ?? AppConstants.defaultCalorieGoal,
        proteinGoal: cached['proteinGoal'] ?? AppConstants.defaultProteinGoal,
        carbsGoal: cached['carbsGoal'] ?? AppConstants.defaultCarbsGoal,
        fatGoal: cached['fatGoal'] ?? AppConstants.defaultFatGoal,
      );
    }
    return null;
  }

  try {
    final user = await apiService.getUser(userId);
    
    // Cache the goals
    await cacheService.cacheUserGoals(userId, {
      'calorieGoal': user.dailyCalorieGoal,
      'proteinGoal': user.dailyProteinGoal,
      'carbsGoal': user.dailyCarbsGoal,
      'fatGoal': user.dailyFatGoal,
    });
    
    return UserGoals(
      calorieGoal: user.dailyCalorieGoal,
      proteinGoal: user.dailyProteinGoal,
      carbsGoal: user.dailyCarbsGoal,
      fatGoal: user.dailyFatGoal,
    );
  } catch (e) {
    // Try cache on error
    final cached = await getFromCache();
    if (cached != null) {
      return cached;
    }
    
    return UserGoals(
      calorieGoal: AppConstants.defaultCalorieGoal,
      proteinGoal: AppConstants.defaultProteinGoal,
      carbsGoal: AppConstants.defaultCarbsGoal,
      fatGoal: AppConstants.defaultFatGoal,
    );
  }
});

// Streak provider - fetches from API
final streakProvider = FutureProvider<int>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authStateProvider);

  final userId = authState.userId;
  if (userId == null) {
    return 0;
  }

  try {
    final response = await apiService.getStreak();
    return response.currentStreak;
  } catch (e) {
    return 0;
  }
});

// Apple Health data provider
final healthDataProvider = FutureProvider<HealthData>((ref) async {
  final healthService = ref.watch(healthServiceProvider);
  
  // Check if authorized
  final isAuthorized = await healthService.checkAuthorization();
  if (!isAuthorized) {
    return const HealthData(
      steps: 0,
      activeCaloriesBurned: 0,
      isConnected: false,
    );
  }

  try {
    final steps = await healthService.getTodaySteps();
    final activeCalories = await healthService.getTodayActiveCaloriesBurned();
    
    return HealthData(
      steps: steps,
      activeCaloriesBurned: activeCalories.round(),
      isConnected: true,
    );
  } catch (e) {
    return const HealthData(
      steps: 0,
      activeCaloriesBurned: 0,
      isConnected: false,
    );
  }
});

class HealthData {
  final int steps;
  final int activeCaloriesBurned;
  final bool isConnected;

  const HealthData({
    required this.steps,
    required this.activeCaloriesBurned,
    required this.isConnected,
  });
}

// Widget updater provider - updates home screen widget and Live Activity when data changes
final widgetUpdaterProvider = Provider<void>((ref) {
  final today = DateTime.now();
  final todayNormalized = DateTime(today.year, today.month, today.day);
  
  final dailySummaryAsync = ref.watch(dailySummaryProvider(todayNormalized));
  final userGoalsAsync = ref.watch(userGoalsProvider);
  final streakAsync = ref.watch(streakProvider);
  final widgetService = ref.watch(widgetServiceProvider);
  final liveActivityService = ref.watch(liveActivityServiceProvider);
  final liveActivityEnabled = ref.watch(liveActivityEnabledProvider);
  
  dailySummaryAsync.whenData((summary) {
    userGoalsAsync.whenData((goals) {
      streakAsync.whenData((streak) {
        final caloriesConsumed = summary.totalCalories;
        final caloriesLeft = (goals.calorieGoal - caloriesConsumed).clamp(0, goals.calorieGoal);
        
        // Calculate remaining macros (goal - consumed), clamp to 0
        final proteinLeft = (goals.proteinGoal - summary.totalProtein).clamp(0.0, goals.proteinGoal.toDouble());
        final carbsLeft = (goals.carbsGoal - summary.totalCarbs).clamp(0.0, goals.carbsGoal.toDouble());
        final fatLeft = (goals.fatGoal - summary.totalFat).clamp(0.0, goals.fatGoal.toDouble());
        
        // Update home screen widget
        widgetService.updateWidgetData(
          caloriesLeft: caloriesLeft,
          caloriesGoal: goals.calorieGoal,
          caloriesConsumed: caloriesConsumed,
          streak: streak,
          protein: proteinLeft,
          carbs: carbsLeft,
          fat: fatLeft,
        );
        
        // Update or start Live Activity if enabled
        if (liveActivityEnabled) {
          if (liveActivityService.isActivityRunning) {
            liveActivityService.updateActivity(
              caloriesLeft: caloriesLeft,
              caloriesGoal: goals.calorieGoal,
              caloriesConsumed: caloriesConsumed,
              proteinLeft: proteinLeft.toInt(),
              carbsLeft: carbsLeft.toInt(),
              fatLeft: fatLeft.toInt(),
            );
          } else {
            // Start Live Activity with current data
            liveActivityService.startActivity(
              caloriesLeft: caloriesLeft,
              caloriesGoal: goals.calorieGoal,
              caloriesConsumed: caloriesConsumed,
              proteinLeft: proteinLeft.toInt(),
              carbsLeft: carbsLeft.toInt(),
              fatLeft: fatLeft.toInt(),
            );
          }
        }
      });
    });
  });
});

// Dates with food data for the current week
final weekDatesWithDataProvider = FutureProvider<Set<DateTime>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final userId = authState.userId;
  if (userId == null) return {};

  final today = DateTime.now();
  final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
  final datesWithData = <DateTime>{};

  // Check each day of the week
  for (int i = 0; i < 7; i++) {
    final date = startOfWeek.add(Duration(days: i));
    if (date.isAfter(today)) continue;

    try {
      final summary = await ref.watch(dailySummaryProvider(date).future);
      if (summary.entries.isNotEmpty) {
        datesWithData.add(DateTime(date.year, date.month, date.day));
      }
    } catch (_) {
      // Ignore errors for individual days
    }
  }

  return datesWithData;
});

// Add food entry action
final addFoodEntryProvider = FutureProvider.family<FoodEntryModel?, AddFoodEntryParams>((ref, params) async {
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authStateProvider);

  final userId = authState.userId;
  if (userId == null) {
    throw Exception('User not authenticated');
  }

  try {
    final entry = await apiService.createFoodEntry(
      name: params.name,
      calories: params.calories,
      protein: params.protein,
      carbs: params.carbs,
      fat: params.fat,
      fiber: params.fiber,
      sugar: params.sugar,
      sodium: params.sodium,
      imageUrl: params.imageUrl,
      ingredients: params.ingredients,
      servings: params.servings,
      loggedAt: params.loggedAt,
    );

    // Invalidate the daily summary to refresh
    ref.invalidate(dailySummaryProvider);

    return entry;
  } catch (e) {
    rethrow;
  }
});

// Delete food entry action
final deleteFoodEntryProvider = FutureProvider.family<void, String>((ref, entryId) async {
  final apiService = ref.watch(apiServiceProvider);

  try {
    await apiService.deleteFoodEntry(entryId);

    // Invalidate the daily summary to refresh
    ref.invalidate(dailySummaryProvider);
  } catch (e) {
    rethrow;
  }
});

class UserGoals {
  final int calorieGoal;
  final int proteinGoal;
  final int carbsGoal;
  final int fatGoal;

  UserGoals({
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  });
}

class AddFoodEntryParams {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final String? imageUrl;
  final List<Map<String, dynamic>>? ingredients;
  final int servings;
  final DateTime? loggedAt;

  AddFoodEntryParams({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0,
    this.sugar = 0,
    this.sodium = 0,
    this.imageUrl,
    this.ingredients,
    this.servings = 1,
    this.loggedAt,
  });
}

// Motivational quotes
final motivationalQuotes = [
  '오늘 하루도 건강하게 시작해요! 💪',
  '작은 변화가 큰 결과를 만듭니다.',
  '꾸준함이 최고의 무기입니다.',
  '건강한 식단이 행복한 삶을 만듭니다.',
  '오늘의 노력이 내일의 나를 만듭니다.',
  '포기하지 마세요, 당신은 할 수 있어요!',
  '한 걸음씩, 목표를 향해 나아가요.',
  '건강은 가장 소중한 재산입니다.',
  '오늘도 멋진 선택을 하셨네요! ✨',
  '당신의 노력은 배신하지 않습니다.',
  '매일 조금씩, 더 나은 내가 되어가요.',
  '건강한 몸에 건강한 마음이 깃듭니다.',
  '작심삼일? 오늘부터 다시 시작하면 됩니다!',
  '스스로를 믿으세요, 당신은 대단해요.',
  '좋은 습관이 좋은 인생을 만듭니다.',
];

// Random quote provider - refreshes daily
final dailyQuoteProvider = Provider<String>((ref) {
  final now = DateTime.now();
  // Use day of year as seed for daily rotation
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final index = dayOfYear % motivationalQuotes.length;
  return motivationalQuotes[index];
});

// Pending food entry provider - tracks food entries being registered from camera
final pendingFoodEntriesProvider = StateProvider<List<String>>((ref) => []);
