import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_entry_model.freezed.dart';
part 'food_entry_model.g.dart';

@freezed
abstract class FoodEntryModel with _$FoodEntryModel {
  const factory FoodEntryModel({
    required String id,
    required String userId,
    required String name,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    String? imageUrl,
    @Default([]) List<IngredientModel> ingredients,
    @Default(1) int servings,
    required DateTime loggedAt,
  }) = _FoodEntryModel;

  factory FoodEntryModel.fromJson(Map<String, dynamic> json) =>
      _$FoodEntryModelFromJson(json);
}

@freezed
abstract class IngredientModel with _$IngredientModel {
  const factory IngredientModel({
    required String name,
    required int calories,
    String? amount,
    double? protein,
    double? carbs,
    double? fat,
  }) = _IngredientModel;

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);
}

@freezed
abstract class DailySummaryModel with _$DailySummaryModel {
  const factory DailySummaryModel({
    required String id,
    required String userId,
    required DateTime date,
    @Default(0) int totalCalories,
    @Default(0.0) double totalProtein,
    @Default(0.0) double totalCarbs,
    @Default(0.0) double totalFat,
    @Default([]) List<FoodEntryModel> entries,
  }) = _DailySummaryModel;

  factory DailySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryModelFromJson(json);
}
