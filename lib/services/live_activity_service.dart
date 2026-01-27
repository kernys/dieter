import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final liveActivityServiceProvider = Provider<LiveActivityService>((ref) {
  return LiveActivityService();
});

// Async provider that loads the saved state and initializes Live Activity
final liveActivityInitProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(liveActivityServiceProvider);
  final enabled = await service.isEnabled();
  
  ref.read(liveActivityEnabledProvider.notifier).state = enabled;
  
  // Don't start here - it will be started by widgetUpdaterProvider with actual data
  return enabled;
});

final liveActivityEnabledProvider = StateProvider<bool>((ref) {
  return false;
});

class LiveActivityService {
  static const _channel = MethodChannel('net.kernys.dietai/live_activity');
  static const _prefsKey = 'live_activity_enabled';
  
  bool _isActivityRunning = false;
  String? _activityId;

  bool get isActivityRunning => _isActivityRunning;
  bool get isSupported => Platform.isIOS;

  /// Check if Live Activity is enabled in settings
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  /// Set Live Activity enabled/disabled
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
    
    if (enabled) {
      await startActivity();
    } else {
      await endActivity();
    }
  }

  /// Start a Live Activity
  Future<bool> startActivity({
    int caloriesLeft = 0,
    int caloriesGoal = 2000,
    int caloriesConsumed = 0,
    int proteinLeft = 0,
    int carbsLeft = 0,
    int fatLeft = 0,
  }) async {
    if (!isSupported) {
      debugPrint('Live Activity: Not supported on this platform');
      return false;
    }

    debugPrint('Live Activity: Starting with caloriesLeft=$caloriesLeft, caloriesGoal=$caloriesGoal');

    try {
      final result = await _channel.invokeMethod<String>('startActivity', {
        'caloriesLeft': caloriesLeft,
        'caloriesGoal': caloriesGoal,
        'caloriesConsumed': caloriesConsumed,
        'proteinLeft': proteinLeft,
        'carbsLeft': carbsLeft,
        'fatLeft': fatLeft,
      });
      
      if (result != null) {
        _activityId = result;
        _isActivityRunning = true;
        debugPrint('Live Activity started with ID: $result');
        return true;
      }
      debugPrint('Live Activity: startActivity returned null');
      return false;
    } on PlatformException catch (e) {
      debugPrint('Live Activity start error: ${e.message} (code: ${e.code}, details: ${e.details})');
      return false;
    } catch (e) {
      debugPrint('Live Activity unexpected error: $e');
      return false;
    }
  }

  /// Update the Live Activity
  Future<bool> updateActivity({
    required int caloriesLeft,
    required int caloriesGoal,
    required int caloriesConsumed,
    required int proteinLeft,
    required int carbsLeft,
    required int fatLeft,
  }) async {
    if (!isSupported || !_isActivityRunning) {
      return false;
    }

    try {
      await _channel.invokeMethod('updateActivity', {
        'activityId': _activityId,
        'caloriesLeft': caloriesLeft,
        'caloriesGoal': caloriesGoal,
        'caloriesConsumed': caloriesConsumed,
        'proteinLeft': proteinLeft,
        'carbsLeft': carbsLeft,
        'fatLeft': fatLeft,
      });
      debugPrint('Live Activity updated');
      return true;
    } on PlatformException catch (e) {
      debugPrint('Live Activity update error: ${e.message}');
      return false;
    }
  }

  /// End the Live Activity
  Future<bool> endActivity() async {
    if (!isSupported || !_isActivityRunning) {
      return false;
    }

    try {
      await _channel.invokeMethod('endActivity', {
        'activityId': _activityId,
      });
      _isActivityRunning = false;
      _activityId = null;
      debugPrint('Live Activity ended');
      return true;
    } on PlatformException catch (e) {
      debugPrint('Live Activity end error: ${e.message}');
      return false;
    }
  }

  /// Check if Live Activities are supported and authorized
  Future<bool> checkSupport() async {
    if (!isSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('checkSupport');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Live Activity check support error: ${e.message}');
      return false;
    }
  }
}
