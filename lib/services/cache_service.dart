import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/models/food_entry_model.dart';
import '../shared/models/user_model.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

class CacheService {
  static const String _userPrefix = 'cached_user_';
  static const String _foodEntriesPrefix = 'cached_food_entries_';
  static const String _dailySummaryPrefix = 'cached_daily_summary_';

  // Cache user data
  Future<void> cacheUser(String userId, UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(user.toJson());
      await prefs.setString('$_userPrefix$userId', json);
      debugPrint('CacheService: Cached user data for $userId');
    } catch (e) {
      debugPrint('CacheService: Failed to cache user: $e');
    }
  }

  // Get cached user data
  Future<UserModel?> getCachedUser(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('$_userPrefix$userId');
      if (json != null) {
        debugPrint('CacheService: Retrieved cached user data for $userId');
        return UserModel.fromJson(jsonDecode(json));
      }
    } catch (e) {
      debugPrint('CacheService: Failed to get cached user: $e');
    }
    return null;
  }

  // Cache food entries for a specific date
  Future<void> cacheFoodEntries(String userId, DateTime date, List<FoodEntryModel> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _formatDate(date);
      final json = jsonEncode(entries.map((e) => e.toJson()).toList());
      await prefs.setString('$_foodEntriesPrefix${userId}_$dateKey', json);
      debugPrint('CacheService: Cached ${entries.length} food entries for $dateKey');
    } catch (e) {
      debugPrint('CacheService: Failed to cache food entries: $e');
    }
  }

  // Get cached food entries
  Future<List<FoodEntryModel>?> getCachedFoodEntries(String userId, DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _formatDate(date);
      final json = prefs.getString('$_foodEntriesPrefix${userId}_$dateKey');
      if (json != null) {
        final list = jsonDecode(json) as List;
        debugPrint('CacheService: Retrieved ${list.length} cached food entries for $dateKey');
        return list.map((e) => FoodEntryModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('CacheService: Failed to get cached food entries: $e');
    }
    return null;
  }

  // Cache daily summary
  Future<void> cacheDailySummary(String userId, DateTime date, Map<String, dynamic> summary) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _formatDate(date);
      final json = jsonEncode(summary);
      await prefs.setString('$_dailySummaryPrefix${userId}_$dateKey', json);
      debugPrint('CacheService: Cached daily summary for $dateKey');
    } catch (e) {
      debugPrint('CacheService: Failed to cache daily summary: $e');
    }
  }

  // Get cached daily summary
  Future<Map<String, dynamic>?> getCachedDailySummary(String userId, DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _formatDate(date);
      final json = prefs.getString('$_dailySummaryPrefix${userId}_$dateKey');
      if (json != null) {
        debugPrint('CacheService: Retrieved cached daily summary for $dateKey');
        return jsonDecode(json);
      }
    } catch (e) {
      debugPrint('CacheService: Failed to get cached daily summary: $e');
    }
    return null;
  }

  // Clear all cached data for a user
  Future<void> clearUserCache(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final userKeys = keys.where((key) =>
        key.contains(userId) ||
        key.startsWith(_userPrefix) ||
        key.startsWith(_foodEntriesPrefix) ||
        key.startsWith(_dailySummaryPrefix)
      ).toList();

      for (final key in userKeys) {
        await prefs.remove(key);
      }
      debugPrint('CacheService: Cleared cache for user $userId');
    } catch (e) {
      debugPrint('CacheService: Failed to clear cache: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
