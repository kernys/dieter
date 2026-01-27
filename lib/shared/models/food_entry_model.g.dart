// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodEntryModel _$FoodEntryModelFromJson(Map<String, dynamic> json) =>
    _FoodEntryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl'] as String?,
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
    );

Map<String, dynamic> _$FoodEntryModelToJson(_FoodEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
      'imageUrl': instance.imageUrl,
      'ingredients': instance.ingredients,
      'servings': instance.servings,
      'loggedAt': instance.loggedAt.toIso8601String(),
    };

_IngredientModel _$IngredientModelFromJson(Map<String, dynamic> json) =>
    _IngredientModel(
      name: json['name'] as String,
      calories: (json['calories'] as num).toInt(),
      amount: json['amount'] as String?,
      protein: (json['protein'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$IngredientModelToJson(_IngredientModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'calories': instance.calories,
      'amount': instance.amount,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
    };

_DailySummaryModel _$DailySummaryModelFromJson(Map<String, dynamic> json) =>
    _DailySummaryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      totalCalories: (json['totalCalories'] as num?)?.toInt() ?? 0,
      totalProtein: (json['totalProtein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['totalCarbs'] as num?)?.toDouble() ?? 0.0,
      totalFat: (json['totalFat'] as num?)?.toDouble() ?? 0.0,
      totalFiber: (json['totalFiber'] as num?)?.toDouble() ?? 0.0,
      totalSugar: (json['totalSugar'] as num?)?.toDouble() ?? 0.0,
      totalSodium: (json['totalSodium'] as num?)?.toDouble() ?? 0.0,
      entries:
          (json['entries'] as List<dynamic>?)
              ?.map((e) => FoodEntryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DailySummaryModelToJson(_DailySummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'totalCalories': instance.totalCalories,
      'totalProtein': instance.totalProtein,
      'totalCarbs': instance.totalCarbs,
      'totalFat': instance.totalFat,
      'totalFiber': instance.totalFiber,
      'totalSugar': instance.totalSugar,
      'totalSodium': instance.totalSodium,
      'entries': instance.entries,
    };
