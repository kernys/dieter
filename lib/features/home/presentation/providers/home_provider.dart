import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/food_entry_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../services/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Selected date provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Daily summary provider - fetches from real API
final dailySummaryProvider = FutureProvider.family<DailySummaryModel, DateTime>((ref, date) async {
  final apiService = ref.watch(apiServiceProvider);
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

  try {
    final response = await apiService.getFoodEntries(userId, date);

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
    // Return empty summary on error
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

// User goals provider - fetches from user settings
final userGoalsProvider = FutureProvider<UserGoals>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
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

  try {
    final user = await apiService.getUser(userId);
    return UserGoals(
      calorieGoal: user.dailyCalorieGoal,
      proteinGoal: user.dailyProteinGoal,
      carbsGoal: user.dailyCarbsGoal,
      fatGoal: user.dailyFatGoal,
    );
  } catch (e) {
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
    final response = await apiService.getStreak(userId);
    return response.currentStreak;
  } catch (e) {
    return 0;
  }
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
      userId: userId,
      name: params.name,
      calories: params.calories,
      protein: params.protein,
      carbs: params.carbs,
      fat: params.fat,
      imageUrl: params.imageUrl,
      ingredients: params.ingredients,
      servings: params.servings,
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
  final String? imageUrl;
  final List<Map<String, dynamic>>? ingredients;
  final int servings;

  AddFoodEntryParams({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
    this.ingredients,
    this.servings = 1,
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
