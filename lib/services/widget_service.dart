import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

final widgetServiceProvider = Provider<WidgetService>((ref) {
  return WidgetService();
});

class WidgetService {
  static const String _appGroupId = 'group.com.calai.calAi';
  static const String _iOSWidgetName = 'CalAiWidget';
  static const String _androidWidgetName = 'CalAiWidgetProvider';

  WidgetService() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(_appGroupId);
    }
  }

  /// Update widget data
  Future<bool> updateWidgetData({
    required int caloriesLeft,
    required int caloriesGoal,
    required int caloriesConsumed,
    required int streak,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    try {
      final widgetData = {
        'caloriesLeft': caloriesLeft,
        'caloriesGoal': caloriesGoal,
        'caloriesConsumed': caloriesConsumed,
        'streak': streak,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

      // Save as JSON string for iOS
      await HomeWidget.saveWidgetData<String>(
        'widget_data',
        jsonEncode(widgetData),
      );

      // Also save individual values for Android
      await HomeWidget.saveWidgetData<int>('calories_left', caloriesLeft);
      await HomeWidget.saveWidgetData<int>('calories_goal', caloriesGoal);
      await HomeWidget.saveWidgetData<int>('calories_consumed', caloriesConsumed);
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.saveWidgetData<double>('protein', protein);
      await HomeWidget.saveWidgetData<double>('carbs', carbs);
      await HomeWidget.saveWidgetData<double>('fat', fat);

      // Update widgets
      if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: _iOSWidgetName);
      } else if (Platform.isAndroid) {
        await HomeWidget.updateWidget(androidName: _androidWidgetName);
      }

      return true;
    } catch (e) {
      debugPrint('Error updating widget data: $e');
      return false;
    }
  }

  /// Register widget callback for interactivity
  Future<void> registerInteractivityCallback(
    Future<void> Function(Uri?) callback,
  ) async {
    try {
      await HomeWidget.registerInteractivityCallback(callback);
    } catch (e) {
      debugPrint('Error registering widget callback: $e');
    }
  }

  /// Check if widgets are supported
  bool get isSupported => Platform.isIOS || Platform.isAndroid;
}
