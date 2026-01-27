import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_activities/live_activities.dart';
import 'package:shared_preferences/shared_preferences.dart';

final liveActivityServiceProvider = Provider<LiveActivityService>((ref) {
  return LiveActivityService();
});

// Provider that initializes Live Activity on app start
final liveActivityInitProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(liveActivityServiceProvider);
  await service.init();
  
  final enabled = await service.isEnabled();
  ref.read(liveActivityEnabledProvider.notifier).state = enabled;
  
  return enabled;
});

final liveActivityEnabledProvider = StateProvider<bool>((ref) {
  return false;
});

class LiveActivityService {
  final _liveActivities = LiveActivities();
  static const _prefsKey = 'live_activity_enabled';
  static const _appGroupId = 'group.dietai';
  static const _activityId = 'calai_daily_tracker';
  
  bool _isInitialized = false;

  bool get isSupported => Platform.isIOS;

  /// Initialize the Live Activities plugin
  Future<void> init() async {
    if (!isSupported || _isInitialized) return;
    
    try {
      await _liveActivities.init(appGroupId: _appGroupId);
      _isInitialized = true;
      
      debugPrint('LiveActivity: Initialized with appGroupId: $_appGroupId');
    } catch (e) {
      debugPrint('LiveActivity: Init error: $e');
    }
  }

  /// Check if Live Activity is enabled in settings
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  /// Check if device supports Live Activities
  Future<bool> checkSupport() async {
    if (!isSupported) return false;
    
    try {
      return await _liveActivities.areActivitiesEnabled();
    } catch (e) {
      debugPrint('LiveActivity: checkSupport error: $e');
      return false;
    }
  }

  /// Set Live Activity enabled/disabled
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
    
    if (!enabled) {
      await endActivity();
    }
  }

  /// Create or update a Live Activity
  Future<bool> createOrUpdateActivity({
    required int caloriesLeft,
    required int caloriesGoal,
    required int caloriesConsumed,
    required int proteinLeft,
    required int carbsLeft,
    required int fatLeft,
  }) async {
    if (!isSupported || !_isInitialized) {
      debugPrint('LiveActivity: Not supported or not initialized');
      return false;
    }

    final enabled = await isEnabled();
    if (!enabled) {
      debugPrint('LiveActivity: Not enabled');
      return false;
    }

    final supported = await checkSupport();
    if (!supported) {
      debugPrint('LiveActivity: Not supported on this device');
      return false;
    }

    try {
      final activityData = <String, dynamic>{
        'caloriesLeft': caloriesLeft,
        'caloriesGoal': caloriesGoal,
        'caloriesConsumed': caloriesConsumed,
        'proteinLeft': proteinLeft,
        'carbsLeft': carbsLeft,
        'fatLeft': fatLeft,
        'progress': caloriesGoal > 0 
            ? (caloriesConsumed / caloriesGoal).clamp(0.0, 1.0) 
            : 0.0,
      };

      debugPrint('LiveActivity: Creating/updating with data: $activityData');

      // Use createOrUpdateActivity - it handles both create and update
      await _liveActivities.createOrUpdateActivity(
        _activityId,
        activityData,
        removeWhenAppIsKilled: false,
      );
      
      debugPrint('LiveActivity: Created/updated activity $_activityId');
      return true;
    } catch (e) {
      debugPrint('LiveActivity: Create/update error: $e');
      return false;
    }
  }

  /// End the current Live Activity
  Future<bool> endActivity() async {
    if (!isSupported || !_isInitialized) return false;

    try {
      await _liveActivities.endActivity(_activityId);
      debugPrint('LiveActivity: Ended activity $_activityId');
      
      // Also end all activities to be safe
      await _liveActivities.endAllActivities();
      
      return true;
    } catch (e) {
      debugPrint('LiveActivity: End error: $e');
      return false;
    }
  }

  /// End all Live Activities
  Future<void> endAllActivities() async {
    if (!isSupported || !_isInitialized) return;
    
    try {
      await _liveActivities.endAllActivities();
      debugPrint('LiveActivity: Ended all activities');
    } catch (e) {
      debugPrint('LiveActivity: End all error: $e');
    }
  }
}
