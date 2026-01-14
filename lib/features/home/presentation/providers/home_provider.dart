import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/food_entry_model.dart';
import '../../../../core/constants/app_constants.dart';

// Selected date provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Daily summary provider
final dailySummaryProvider = FutureProvider.family<DailySummaryModel, DateTime>((ref, date) async {
  // TODO: Fetch from Supabase
  // For now, return mock data
  await Future.delayed(const Duration(milliseconds: 500));

  return DailySummaryModel(
    id: 'summary-1',
    userId: 'user-1',
    date: date,
    totalCalories: 1250,
    totalProtein: 75,
    totalCarbs: 138,
    totalFat: 35,
    entries: [
      FoodEntryModel(
        id: 'entry-1',
        userId: 'user-1',
        name: 'Grilled Salmon',
        calories: 550,
        protein: 35,
        carbs: 40,
        fat: 28,
        imageUrl: null,
        ingredients: [
          const IngredientModel(name: 'Salmon', calories: 400, amount: '200g'),
          const IngredientModel(name: 'Olive Oil', calories: 100, amount: '1 tbsp'),
          const IngredientModel(name: 'Vegetables', calories: 50, amount: '1 cup'),
        ],
        loggedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      FoodEntryModel(
        id: 'entry-2',
        userId: 'user-1',
        name: 'Caesar Salad',
        calories: 330,
        protein: 8,
        carbs: 20,
        fat: 18,
        imageUrl: null,
        ingredients: [
          const IngredientModel(name: 'Lettuce', calories: 20, amount: '1.5 cups'),
          const IngredientModel(name: 'Croutons', calories: 100, amount: '0.5 cup'),
          const IngredientModel(name: 'Parmesan', calories: 80, amount: '2 tbsp'),
          const IngredientModel(name: 'Caesar Dressing', calories: 130, amount: '2 tbsp'),
        ],
        loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FoodEntryModel(
        id: 'entry-3',
        userId: 'user-1',
        name: 'Morning Oatmeal',
        calories: 370,
        protein: 12,
        carbs: 58,
        fat: 8,
        imageUrl: null,
        ingredients: [
          const IngredientModel(name: 'Oats', calories: 150, amount: '1 cup'),
          const IngredientModel(name: 'Banana', calories: 100, amount: '1 medium'),
          const IngredientModel(name: 'Honey', calories: 60, amount: '1 tbsp'),
          const IngredientModel(name: 'Almonds', calories: 60, amount: '10 pieces'),
        ],
        loggedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ],
  );
});

// User goals provider
final userGoalsProvider = Provider<UserGoals>((ref) {
  // TODO: Fetch from user settings
  return UserGoals(
    calorieGoal: AppConstants.defaultCalorieGoal,
    proteinGoal: AppConstants.defaultProteinGoal,
    carbsGoal: AppConstants.defaultCarbsGoal,
    fatGoal: AppConstants.defaultFatGoal,
  );
});

// Streak provider
final streakProvider = Provider<int>((ref) {
  // TODO: Calculate from actual data
  return 15;
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
