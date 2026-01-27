import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedFood {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final String? imageUrl;
  final DateTime savedAt;

  SavedFood({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0,
    this.sugar = 0,
    this.sodium = 0,
    this.imageUrl,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'fiber': fiber,
    'sugar': sugar,
    'sodium': sodium,
    'imageUrl': imageUrl,
    'savedAt': savedAt.toIso8601String(),
  };

  factory SavedFood.fromJson(Map<String, dynamic> json) => SavedFood(
    id: json['id'] as String,
    name: json['name'] as String,
    calories: json['calories'] as int,
    protein: (json['protein'] as num).toDouble(),
    carbs: (json['carbs'] as num).toDouble(),
    fat: (json['fat'] as num).toDouble(),
    fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
    sugar: (json['sugar'] as num?)?.toDouble() ?? 0,
    sodium: (json['sodium'] as num?)?.toDouble() ?? 0,
    imageUrl: json['imageUrl'] as String?,
    savedAt: DateTime.parse(json['savedAt'] as String),
  );
}

class SavedFoodsNotifier extends StateNotifier<List<SavedFood>> {
  SavedFoodsNotifier() : super([]) {
    _loadSavedFoods();
  }

  static const _storageKey = 'saved_foods';

  Future<void> _loadSavedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      state = jsonList.map((json) => SavedFood.fromJson(json)).toList();
    }
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((f) => f.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> addFood(SavedFood food) async {
    // Check if already saved (by name)
    if (state.any((f) => f.name.toLowerCase() == food.name.toLowerCase())) {
      return; // Already saved
    }
    state = [...state, food];
    await _saveToDisk();
  }

  Future<void> removeFood(String id) async {
    state = state.where((f) => f.id != id).toList();
    await _saveToDisk();
  }

  bool isSaved(String name) {
    return state.any((f) => f.name.toLowerCase() == name.toLowerCase());
  }
}

final savedFoodsProvider = StateNotifierProvider<SavedFoodsNotifier, List<SavedFood>>((ref) {
  return SavedFoodsNotifier();
});
