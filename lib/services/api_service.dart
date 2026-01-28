import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../shared/models/badge_model.dart';
import '../shared/models/food_entry_model.dart';
import '../shared/models/group_model.dart';
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

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: _headers,
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw ApiException(response.statusCode, errorBody['error'] ?? 'Failed to send reset email');
    }
  }

  // User APIs
  Future<UserModel> getUser(String userId) async {
    try {
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
    } catch (e) {
      // Network errors (connection refused, timeout, no internet, etc.)
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
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
  Future<FoodEntriesResponse> getFoodEntries(DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final response = await http.get(
      Uri.parse('$baseUrl/food-entries?date=$dateStr'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return FoodEntriesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to get food entries');
    }
  }

  Future<FoodEntryModel> createFoodEntry({
    required String name,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    double fiber = 0,
    double sugar = 0,
    double sodium = 0,
    String? imageUrl,
    List<Map<String, dynamic>>? ingredients,
    int servings = 1,
    DateTime? loggedAt, // Optional: specify date for past entries
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/food-entries'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'fiber': fiber,
        'sugar': sugar,
        'sodium': sodium,
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'servings': servings,
        // Use noon (12:00) of the local date to avoid timezone issues
        // This ensures the date stays the same after UTC conversion for most timezones
        if (loggedAt != null) 'loggedAt': DateTime(loggedAt.year, loggedAt.month, loggedAt.day, 12, 0, 0).toUtc().toIso8601String(),
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

  /// Upload an image using Vercel Blob client upload.
  /// 1. Get upload token from server
  /// 2. Upload directly to Vercel Blob API
  Future<String> _uploadImageToBlob(Uint8List imageBytes) async {
    // Step 1: Get client token from our server
    final tokenResponse = await http.post(
      Uri.parse('$baseUrl/upload'),
      headers: _headers,
    );

    if (tokenResponse.statusCode != 200) {
      final errorBody = jsonDecode(tokenResponse.body);
      throw ApiException(tokenResponse.statusCode, errorBody['error'] ?? 'Failed to get upload token');
    }

    final tokenData = jsonDecode(tokenResponse.body);
    final clientToken = tokenData['clientToken'] as String;
    final pathname = tokenData['pathname'] as String;

    // Step 2: Upload directly to Vercel Blob API using the client token
    final uploadUrl = Uri.parse('https://vercel.com/api/blob').replace(
      queryParameters: {'pathname': pathname},
    );
    
    final uploadResponse = await http.put(
      uploadUrl,
      headers: {
        'Authorization': 'Bearer $clientToken',
        'Content-Type': 'image/jpeg',
        'x-api-version': '11',
      },
      body: imageBytes,
    );

    if (uploadResponse.statusCode == 200) {
      final data = jsonDecode(uploadResponse.body);
      return data['url'] as String;
    } else {
      debugPrint('Blob upload failed: ${uploadResponse.statusCode} - ${uploadResponse.body}');
      throw ApiException(uploadResponse.statusCode, 'Failed to upload image to storage');
    }
  }

  /// Analyze food image and optionally auto-register the food entry.
  /// Returns both analysis result and the created entry if autoRegister is true.
  Future<FoodAnalysisWithEntryResult> analyzeFoodAndRegister(
    Uint8List imageBytes, {
    String? locale,
    bool autoRegister = true,
    DateTime? loggedAt, // Optional: specify date for past entries
  }) async {
    // Step 1: Upload the image permanently
    final imageUrl = await _uploadImageToBlob(imageBytes);

    // Step 2: Send the URL for analysis with autoRegister flag
    final response = await http.post(
      Uri.parse('$baseUrl/food-entries/analyze'),
      headers: _headers,
      body: jsonEncode({
        'imageUrl': imageUrl,
        if (locale != null) 'locale': locale,
        'autoRegister': autoRegister,
        // Use noon (12:00) of the local date to avoid timezone issues
        if (loggedAt != null) 'loggedAt': DateTime(loggedAt.year, loggedAt.month, loggedAt.day, 12, 0, 0).toUtc().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return FoodAnalysisWithEntryResult.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to analyze food');
    }
  }

  /// Analyze food image without registering (for preview/editing before save)
  Future<FoodAnalysisResult> analyzeFood(Uint8List imageBytes, {String? locale}) async {
    // Step 1: Upload the image permanently
    final imageUrl = await _uploadImageToBlob(imageBytes);

    // Step 2: Send the URL for analysis without autoRegister
    final response = await http.post(
      Uri.parse('$baseUrl/food-entries/analyze'),
      headers: _headers,
      body: jsonEncode({
        'imageUrl': imageUrl,
        if (locale != null) 'locale': locale,
        'autoRegister': false,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Add imageUrl to the result for later use
      data['imageUrl'] = imageUrl;
      return FoodAnalysisResult.fromJson(data);
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

  // Image Upload API (uses client-side Blob upload)
  Future<String> uploadImage(dynamic imageData) async {
    if (imageData is File) {
      return _uploadImageToBlob(await imageData.readAsBytes());
    }
    return _uploadImageToBlob(imageData as Uint8List);
  }

  // Weight Log APIs
  Future<WeightLogsResponse> getWeightLogs({String range = '6m'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weight-logs?range=$range'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return WeightLogsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to get weight logs');
    }
  }

  Future<WeightLogModel> createWeightLog({
    required double weight,
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/weight-logs'),
      headers: _headers,
      body: jsonEncode({
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
  Future<StreakResponse> getStreak() async {
    // Send timezone offset in minutes (e.g., Asia/Seoul = +540)
    final tzOffset = DateTime.now().timeZoneOffset.inMinutes;
    final response = await http.get(
      Uri.parse('$baseUrl/stats/streak?tzOffset=$tzOffset'),
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

  // Create Exercise Entry
  Future<void> createExerciseEntry({
    required String type,
    required int duration,
    required int caloriesBurned,
    String? intensity,
    String? description,
    DateTime? loggedAt,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exercise-entries'),
      headers: _headers,
      body: jsonEncode({
        'type': type,
        'duration': duration,
        'caloriesBurned': caloriesBurned,
        if (intensity != null) 'intensity': intensity,
        if (description != null) 'description': description,
        // Use noon (12:00) of the local date to avoid timezone issues
        if (loggedAt != null) 'loggedAt': DateTime(loggedAt.year, loggedAt.month, loggedAt.day, 12, 0, 0).toUtc().toIso8601String(),
      }),
    );

    if (response.statusCode != 201) {
      throw ApiException(response.statusCode, 'Failed to create exercise entry');
    }
  }

  // Get Exercise Entries
  Future<ExerciseEntriesResponse> getExerciseEntries(DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final response = await http.get(
      Uri.parse('$baseUrl/exercise-entries?date=$dateStr'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return ExerciseEntriesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to get exercise entries');
    }
  }

  // Coach Chat API
  Future<CoachResponse> sendCoachMessage({
    required List<CoachMessage> messages,
    String? locale,
    CoachContext? context,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/coach'),
      headers: _headers,
      body: jsonEncode({
        'messages': messages.map((m) => m.toJson()).toList(),
        if (locale != null) 'locale': locale,
        if (context != null) 'context': context.toJson(),
      }),
    );

    if (response.statusCode == 200) {
      return CoachResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(response.statusCode, 'Failed to get coach response');
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

  // Groups APIs
  Future<List<GroupModel>> getGroups() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final groups = (data['groups'] as List)
            .map((json) => GroupModel.fromJson(json))
            .toList();
        return groups;
      } else {
        throw ApiException(response.statusCode, 'Failed to get groups');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<List<GroupModel>> getMyGroups() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/my'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final groups = (data['groups'] as List)
            .map((json) => GroupModel.fromJson(json))
            .toList();
        return groups;
      } else {
        throw ApiException(response.statusCode, 'Failed to get my groups');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<GroupModel> getGroup(String groupId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/$groupId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return GroupModel.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException(response.statusCode, 'Failed to get group');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<GroupModel> createGroup({
    required String name,
    required String description,
    String? imageUrl,
    bool isPrivate = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/groups'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'description': description,
          if (imageUrl != null) 'imageUrl': imageUrl,
          'isPrivate': isPrivate,
        }),
      );

      if (response.statusCode == 201) {
        return GroupModel.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException(response.statusCode, 'Failed to create group');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/groups/$groupId/join'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw ApiException(response.statusCode, 'Failed to join group');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/groups/$groupId/leave'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw ApiException(response.statusCode, 'Failed to leave group');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/$groupId/members'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final members = (data['members'] as List)
            .map((json) => GroupMember.fromJson({
              'id': json['id'],
              'userId': json['userId'],
              'username': json['userName'],
              'profileImage': json['avatarUrl'],
              'score': json['score'],
              'rank': json['rank'],
            }))
            .toList();
        return members;
      } else {
        throw ApiException(response.statusCode, 'Failed to get group members');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<List<GroupMessage>> getGroupMessages(String groupId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/$groupId/messages'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = (data['messages'] as List)
            .map((json) => _parseGroupMessage(json))
            .toList();
        return messages;
      } else {
        throw ApiException(response.statusCode, 'Failed to get group messages');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<GroupMessage> sendGroupMessage(String groupId, String message, {String? imageUrl, String? replyToId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/groups/$groupId/messages'),
        headers: _headers,
        body: jsonEncode({
          if (message.isNotEmpty) 'message': message,
          if (imageUrl != null) 'imageUrl': imageUrl,
          if (replyToId != null) 'replyToId': replyToId,
        }),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return _parseGroupMessage(json);
      } else {
        throw ApiException(response.statusCode, 'Failed to send message');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<void> toggleMessageReaction(String groupId, String messageId, String emoji) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/groups/$groupId/messages/$messageId/reactions'),
        headers: _headers,
        body: jsonEncode({'emoji': emoji}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(response.statusCode, 'Failed to toggle reaction');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<List<GroupMessage>> getMessageReplies(String groupId, String messageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/$groupId/messages/$messageId/replies'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> repliesJson = json['replies'] ?? [];
        return repliesJson.map((r) => _parseGroupMessage(r)).toList();
      } else {
        throw ApiException(response.statusCode, 'Failed to get replies');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  GroupMessage _parseGroupMessage(Map<String, dynamic> json) {
    return GroupMessage(
      id: json['id'],
      groupId: json['groupId'],
      userId: json['userId'],
      username: json['userName'] ?? 'Unknown',
      userProfileImage: json['avatarUrl'],
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'],
      replyToId: json['replyToId'],
      replyTo: json['replyTo'] != null ? _parseGroupMessage(json['replyTo']) : null,
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map((r) => MessageReaction.fromJson(r))
          .toList() ?? [],
      replyCount: json['replyCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Badge APIs
  Future<BadgesResponse> getBadges() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/badges'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return BadgesResponse.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException(response.statusCode, 'Failed to get badges');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<List<BadgeModel>> checkBadges() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/badges/check'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json['newBadges'] as List<dynamic>?)
            ?.map((e) => BadgeModel.fromJson(e))
            .toList() ?? [];
      } else {
        throw ApiException(response.statusCode, 'Failed to check badges');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
    }
  }

  Future<void> markBadgeSeen(String badgeId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/badges/$badgeId/mark-seen'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw ApiException(response.statusCode, 'Failed to mark badge as seen');
      }
    } catch (e) {
      if (e is! ApiException) {
        throw ApiException(0, 'Network error: ${e.toString()}', isNetworkError: true);
      }
      rethrow;
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
  final String source; // 'database' or 'ai'
  final List<Map<String, dynamic>> ingredients;

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
    this.source = 'database',
    this.ingredients = const [],
  });

  bool get isAiGenerated => source == 'ai';

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
      source: json['source'] ?? 'database',
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList() ?? [],
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
  final String? imageUrl; // URL of the uploaded image

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
    this.imageUrl,
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
      imageUrl: json['imageUrl'],
    );
  }
}

/// Result of food analysis with auto-registered entry
class FoodAnalysisWithEntryResult extends FoodAnalysisResult {
  final FoodEntryModel? entry; // The created food entry if autoRegister was true

  FoodAnalysisWithEntryResult({
    required super.name,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
    required super.fiber,
    required super.sugar,
    required super.sodium,
    required super.healthScore,
    required super.ingredients,
    super.imageUrl,
    this.entry,
  });

  factory FoodAnalysisWithEntryResult.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisWithEntryResult(
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
      imageUrl: json['imageUrl'],
      entry: json['entry'] != null ? FoodEntryModel.fromJson(json['entry']) : null,
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

class ExerciseEntriesResponse {
  final List<ExerciseEntryModel> entries;
  final int totalCaloriesBurned;
  final int entryCount;

  ExerciseEntriesResponse({
    required this.entries,
    required this.totalCaloriesBurned,
    required this.entryCount,
  });

  factory ExerciseEntriesResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseEntriesResponse(
      entries: (json['entries'] as List)
          .map((e) => ExerciseEntryModel.fromJson(e))
          .toList(),
      totalCaloriesBurned: (json['summary']?['totalCaloriesBurned'] as num?)?.toInt() ?? 0,
      entryCount: (json['summary']?['entryCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class ExerciseEntryModel {
  final String id;
  final String userId;
  final String type;
  final int duration;
  final int caloriesBurned;
  final String? intensity;
  final String? description;
  final DateTime loggedAt;

  ExerciseEntryModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.duration,
    required this.caloriesBurned,
    this.intensity,
    this.description,
    required this.loggedAt,
  });

  factory ExerciseEntryModel.fromJson(Map<String, dynamic> json) {
    return ExerciseEntryModel(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toInt() ?? 0,
      intensity: json['intensity'],
      description: json['description'],
      loggedAt: DateTime.parse(json['loggedAt']),
    );
  }
}

class CoachMessage {
  final String role; // 'user' or 'assistant'
  final String content;

  CoachMessage({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };
}

class CoachContext {
  final double? currentWeight;
  final double? goalWeight;
  final String? weightUnit; // 'kg' or 'lbs'
  final int? dailyCalorieGoal;
  final int? todayCalories;
  final int? streakDays;

  CoachContext({
    this.currentWeight,
    this.goalWeight,
    this.weightUnit,
    this.dailyCalorieGoal,
    this.todayCalories,
    this.streakDays,
  });

  Map<String, dynamic> toJson() => {
    if (currentWeight != null) 'currentWeight': currentWeight,
    if (goalWeight != null) 'goalWeight': goalWeight,
    if (weightUnit != null) 'weightUnit': weightUnit,
    if (dailyCalorieGoal != null) 'dailyCalorieGoal': dailyCalorieGoal,
    if (todayCalories != null) 'todayCalories': todayCalories,
    if (streakDays != null) 'streakDays': streakDays,
  };
}

class CoachResponse {
  final String reply;
  final DateTime timestamp;

  CoachResponse({
    required this.reply,
    required this.timestamp,
  });

  factory CoachResponse.fromJson(Map<String, dynamic> json) {
    return CoachResponse(
      reply: json['reply'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final bool isNetworkError;

  ApiException(this.statusCode, this.message, {this.isNetworkError = false});

  @override
  String toString() => 'ApiException: $statusCode - $message${isNetworkError ? ' (Network Error)' : ''}';
}
