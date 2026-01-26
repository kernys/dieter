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
  static const String _userGoalsPrefix = 'cached_user_goals_';
  static const String _lastSyncPrefix = 'last_sync_';

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

  // Cache user goals
  Future<void> cacheUserGoals(String userId, Map<String, dynamic> goals) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(goals);
      await prefs.setString('$_userGoalsPrefix$userId', json);
      debugPrint('CacheService: Cached user goals for $userId');
    } catch (e) {
      debugPrint('CacheService: Failed to cache user goals: $e');
    }
  }

  // Get cached user goals
  Future<Map<String, dynamic>?> getCachedUserGoals(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('$_userGoalsPrefix$userId');
      if (json != null) {
        debugPrint('CacheService: Retrieved cached user goals for $userId');
        return jsonDecode(json);
      }
    } catch (e) {
      debugPrint('CacheService: Failed to get cached user goals: $e');
    }
    return null;
  }

  // Track last sync time for a key
  Future<void> setLastSync(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$_lastSyncPrefix$key', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('CacheService: Failed to set last sync: $e');
    }
  }

  // Get last sync time
  Future<DateTime?> getLastSync(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('$_lastSyncPrefix$key');
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      debugPrint('CacheService: Failed to get last sync: $e');
    }
    return null;
  }

  // Check if cache is stale (older than maxAge)
  Future<bool> isCacheStale(String key, Duration maxAge) async {
    final lastSync = await getLastSync(key);
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync) > maxAge;
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
        key.startsWith(_dailySummaryPrefix) ||
        key.startsWith(_userGoalsPrefix)
      ).toList();

      for (final key in userKeys) {
        await prefs.remove(key);
      }
      debugPrint('CacheService: Cleared cache for user $userId');
    } catch (e) {
      debugPrint('CacheService: Failed to clear cache: $e');
    }
  }

  // Clean up old cache entries (older than 30 days)
  Future<void> cleanupOldCache(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      for (final key in keys) {
        if (key.startsWith(_foodEntriesPrefix) || key.startsWith(_dailySummaryPrefix)) {
          // Extract date from key
          final dateMatch = RegExp(r'(\d{4}-\d{2}-\d{2})$').firstMatch(key);
          if (dateMatch != null) {
            final dateStr = dateMatch.group(1)!;
            final parts = dateStr.split('-');
            final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
            if (date.isBefore(thirtyDaysAgo)) {
              await prefs.remove(key);
              debugPrint('CacheService: Removed old cache entry: $key');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('CacheService: Failed to cleanup old cache: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
