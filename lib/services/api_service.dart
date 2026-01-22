import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../shared/models/food_entry_model.dart';
import '../shared/models/user_model.dart';
import '../shared/models/weight_log_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Auth APIs
  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _authToken = data['session']['accessToken'];
      return AuthResponse.fromJson(data);
    } else {
      throw ApiException(response.statusCode, jsonDecode(response.body)['error']);
    }
  }

  Future<AuthResponse> signup(String email, String password, String? name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        if (name != null) 'name': name,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, jsonDecode(response.body)['error']);
    }
  }

  // User APIs
  Future<UserModel> getUser(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('getUser response - goalWeight: ${json['goalWeight']}');
      return UserModel.fromJson(json);
    } else {
      throw ApiException(response.statusCode, 'Failed to get user');
    }
  }

  Future<UserModel> updateUser(String userId, Map<String, dynamic> updates) async {
    debugPrint('updateUser request - updates: $updates');
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$userId'),
      headers: _headers,
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('updateUser response - goalWeight: ${json['goalWeight']}');
      return UserModel.fromJson(json);
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to update user';
      throw ApiException(response.statusCode, errorMessage);
    }
  }

  // Food Entry APIs
  Future<FoodEntriesResponse> getFoodEntries(String userId, DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final response = await http.get(
      Uri.parse('$baseUrl/food-entries?userId=$userId&date=$dateStr'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return FoodEntriesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to get food entries');
    }
  }

  Future<FoodEntryModel> createFoodEntry({
    required String userId,
    required String name,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    String? imageUrl,
    List<Map<String, dynamic>>? ingredients,
    int servings = 1,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/food-entries'),
      headers: _headers,
      body: jsonEncode({
        'userId': userId,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'servings': servings,
      }),
    );

    if (response.statusCode == 201) {
      return FoodEntryModel.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to create food entry';
      final details = errorBody['details'];
      throw ApiException(response.statusCode, details != null ? '$errorMessage: $details' : errorMessage);
    }
  }

  Future<void> deleteFoodEntry(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/food-entries/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, 'Failed to delete food entry');
    }
  }

  Future<FoodAnalysisResult> analyzeFood(Uint8List imageBytes, {String? locale}) async {
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('$baseUrl/food-entries/analyze'),
      headers: _headers,
      body: jsonEncode({
        'image': base64Image,
        if (locale != null) 'locale': locale,
      }),
    );

    if (response.statusCode == 200) {
      return FoodAnalysisResult.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to analyze food');
    }
  }

  Future<FoodAnalysisResult> analyzeTextFood(String description, {String? locale}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/food-entries/analyze-text'),
      headers: _headers,
      body: jsonEncode({
        'description': description,
        if (locale != null) 'locale': locale,
      }),
    );

    if (response.statusCode == 200) {
      return FoodAnalysisResult.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to analyze food description');
    }
  }

  // Image Upload API
  Future<String> uploadImage(Uint8List imageBytes) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'food_image.jpg',
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'] as String;
    } else {
      throw ApiException(response.statusCode, 'Failed to upload image');
    }
  }

  // Weight Log APIs
  Future<WeightLogsResponse> getWeightLogs(String userId, {String range = '6m'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weight-logs?userId=$userId&range=$range'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return WeightLogsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to get weight logs');
    }
  }

  Future<WeightLogModel> createWeightLog({
    required String userId,
    required double weight,
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/weight-logs'),
      headers: _headers,
      body: jsonEncode({
        'userId': userId,
        'weight': weight,
        'note': note ?? '',  // Server expects string, not null
      }),
    );

    if (response.statusCode == 201) {
      return WeightLogModel.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to create weight log';
      final details = errorBody['details'];
      throw ApiException(response.statusCode, details != null ? '$errorMessage: $details' : errorMessage);
    }
  }

  Future<void> deleteWeightLog(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/weight-logs/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, 'Failed to delete weight log');
    }
  }

  // Streak API
  Future<StreakResponse> getStreak(String userId) async {
    // Send timezone offset in minutes (e.g., Asia/Seoul = +540)
    final tzOffset = DateTime.now().timeZoneOffset.inMinutes;
    final response = await http.get(
      Uri.parse('$baseUrl/stats/streak?userId=$userId&tzOffset=$tzOffset'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return StreakResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to get streak');
    }
  }

  // Exercise Analysis API
  Future<ExerciseAnalysisResult> analyzeExercise(String description, {String? locale}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exercise/analyze'),
      headers: _headers,
      body: jsonEncode({
        'description': description,
        if (locale != null) 'locale': locale,
      }),
    );

    if (response.statusCode == 200) {
      return ExerciseAnalysisResult.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to analyze exercise');
    }
  }

  // Food Search API
  Future<FoodSearchResponse> searchFood(String query, {String lang = 'en'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/food-search?name=${Uri.encodeComponent(query)}&lang=$lang'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return FoodSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to search food');
    }
  }

  // Barcode Search API
  Future<BarcodeSearchResult> searchBarcode(String barcode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/barcode-search?barcode=${Uri.encodeComponent(barcode)}'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return BarcodeSearchResult.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return BarcodeSearchResult(found: false, barcode: barcode);
    } else {
      throw ApiException(response.statusCode, 'Failed to search barcode');
    }
  }
}

// Response Models
class AuthResponse {
  final Map<String, dynamic> user;
  final Map<String, dynamic>? session;
  final String? message;

  AuthResponse({required this.user, this.session, this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: json['user'],
      session: json['session'],
      message: json['message'],
    );
  }
}

class FoodEntriesResponse {
  final List<FoodEntryModel> entries;
  final DailySummary summary;

  FoodEntriesResponse({required this.entries, required this.summary});

  factory FoodEntriesResponse.fromJson(Map<String, dynamic> json) {
    return FoodEntriesResponse(
      entries: (json['entries'] as List)
          .map((e) => FoodEntryModel.fromJson(e))
          .toList(),
      summary: DailySummary.fromJson(json['summary']),
    );
  }
}

class DailySummary {
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  DailySummary({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      totalCalories: json['totalCalories'],
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
    );
  }
}

class WeightLogsResponse {
  final List<WeightLogModel> logs;
  final WeightStats stats;

  WeightLogsResponse({required this.logs, required this.stats});

  factory WeightLogsResponse.fromJson(Map<String, dynamic> json) {
    return WeightLogsResponse(
      logs: (json['logs'] as List)
          .map((e) => WeightLogModel.fromJson(e))
          .toList(),
      stats: WeightStats.fromJson(json['stats']),
    );
  }
}

class WeightStats {
  final double currentWeight;
  final double startWeight;
  final double minWeight;
  final double maxWeight;
  final double avgWeight;
  final double totalChange;
  final int totalEntries;

  WeightStats({
    required this.currentWeight,
    required this.startWeight,
    required this.minWeight,
    required this.maxWeight,
    required this.avgWeight,
    required this.totalChange,
    required this.totalEntries,
  });

  factory WeightStats.fromJson(Map<String, dynamic> json) {
    return WeightStats(
      currentWeight: (json['currentWeight'] as num).toDouble(),
      startWeight: (json['startWeight'] as num).toDouble(),
      minWeight: (json['minWeight'] as num).toDouble(),
      maxWeight: (json['maxWeight'] as num).toDouble(),
      avgWeight: (json['avgWeight'] as num).toDouble(),
      totalChange: (json['totalChange'] as num).toDouble(),
      totalEntries: json['totalEntries'],
    );
  }
}

class StreakResponse {
  final int currentStreak;
  final int maxStreak;
  final List<bool> weekData;
  final int totalDaysLogged;

  StreakResponse({
    required this.currentStreak,
    required this.maxStreak,
    required this.weekData,
    required this.totalDaysLogged,
  });

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      currentStreak: json['currentStreak'],
      maxStreak: json['maxStreak'],
      weekData: (json['weekData'] as List).map((e) => e as bool).toList(),
      totalDaysLogged: json['totalDaysLogged'],
    );
  }
}

class FoodSearchResponse {
  final List<FoodSearchItem> foods;
  final String query;

  FoodSearchResponse({required this.foods, required this.query});

  factory FoodSearchResponse.fromJson(Map<String, dynamic> json) {
    return FoodSearchResponse(
      foods: (json['foods'] as List?)
          ?.map((e) => FoodSearchItem.fromJson(e))
          .toList() ?? [],
      query: json['query'] ?? '',
    );
  }
}

class FoodSearchItem {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final String servingSize;
  final String? imageUrl;

  FoodSearchItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.servingSize,
    this.imageUrl,
  });

  factory FoodSearchItem.fromJson(Map<String, dynamic> json) {
    return FoodSearchItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0.0,
      servingSize: json['servingSize'] ?? '100g',
      imageUrl: json['imageUrl'],
    );
  }
}

class BarcodeSearchResult {
  final bool found;
  final String barcode;
  final String? name;
  final String? brand;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? fiber;
  final double? sugar;
  final double? sodium;
  final String? servingSize;
  final String? imageUrl;

  BarcodeSearchResult({
    required this.found,
    required this.barcode,
    this.name,
    this.brand,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.sugar,
    this.sodium,
    this.servingSize,
    this.imageUrl,
  });

  factory BarcodeSearchResult.fromJson(Map<String, dynamic> json) {
    return BarcodeSearchResult(
      found: json['found'] ?? true,
      barcode: json['barcode'] ?? '',
      name: json['name'],
      brand: json['brand'],
      calories: (json['calories'] as num?)?.toInt(),
      protein: (json['protein'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      sugar: (json['sugar'] as num?)?.toDouble(),
      sodium: (json['sodium'] as num?)?.toDouble(),
      servingSize: json['servingSize'],
      imageUrl: json['imageUrl'],
    );
  }
}

class FoodAnalysisResult {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final int healthScore;
  final List<IngredientAnalysis> ingredients;

  FoodAnalysisResult({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.healthScore,
    required this.ingredients,
  });

  factory FoodAnalysisResult.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisResult(
      name: json['name'] ?? 'Unknown Food',
      calories: json['calories'] ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0.0,
      healthScore: (json['health_score'] as num?)?.toInt() ?? 5,
      ingredients: (json['ingredients'] as List?)
          ?.map((e) => IngredientAnalysis.fromJson(e))
          .toList() ?? [],
    );
  }
}

class IngredientAnalysis {
  final String name;
  final String? amount;
  final int calories;
  final double? protein;
  final double? carbs;
  final double? fat;

  IngredientAnalysis({
    required this.name,
    this.amount,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });

  factory IngredientAnalysis.fromJson(Map<String, dynamic> json) {
    return IngredientAnalysis(
      name: json['name'] ?? 'Unknown',
      amount: json['amount'],
      calories: json['calories'] ?? 0,
      protein: (json['protein'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
    );
  }
}

class ExerciseAnalysisResult {
  final String exerciseType;
  final int duration;
  final int caloriesBurned;
  final String? intensity;
  final String? description;

  ExerciseAnalysisResult({
    required this.exerciseType,
    required this.duration,
    required this.caloriesBurned,
    this.intensity,
    this.description,
  });

  factory ExerciseAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ExerciseAnalysisResult(
      exerciseType: json['exercise_type'] ?? json['exerciseType'] ?? 'Exercise',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['calories_burned'] as num?)?.toInt() ??
                      (json['caloriesBurned'] as num?)?.toInt() ?? 0,
      intensity: json['intensity'],
      description: json['description'],
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
