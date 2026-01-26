import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../shared/models/user_model.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Notification IDs
  static const int _breakfastId = 1;
  static const int _lunchId = 2;
  static const int _snackId = 3;
  static const int _dinnerId = 4;
  static const int _endOfDayId = 5;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    debugPrint('NotificationService: Initialized successfully');
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('NotificationService: Notification tapped - ${response.payload}');
    // Handle notification tap - could navigate to specific screen
  }

  /// Request notification permissions (iOS)
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final result = await androidPlugin?.requestNotificationsPermission();
      return result ?? false;
    }
    return false;
  }

  /// Schedule all meal reminders based on user settings
  Future<void> scheduleAllReminders(UserModel user) async {
    if (!_isInitialized) {
      await initialize();
    }

    debugPrint('NotificationService: Scheduling all reminders for user');

    // Cancel all existing reminders first
    await cancelAllReminders();

    // Schedule each reminder if enabled
    if (user.breakfastReminderEnabled) {
      await _scheduleDailyReminder(
        id: _breakfastId,
        time: user.breakfastReminderTime,
        title: '아침 식사 기록',
        body: '아침 식사를 기록해주세요! 🍳',
      );
    }

    if (user.lunchReminderEnabled) {
      await _scheduleDailyReminder(
        id: _lunchId,
        time: user.lunchReminderTime,
        title: '점심 식사 기록',
        body: '점심 식사를 기록해주세요! 🍱',
      );
    }

    if (user.snackReminderEnabled) {
      await _scheduleDailyReminder(
        id: _snackId,
        time: user.snackReminderTime,
        title: '간식 기록',
        body: '간식을 드셨다면 기록해주세요! 🍎',
      );
    }

    if (user.dinnerReminderEnabled) {
      await _scheduleDailyReminder(
        id: _dinnerId,
        time: user.dinnerReminderTime,
        title: '저녁 식사 기록',
        body: '저녁 식사를 기록해주세요! 🍽️',
      );
    }

    if (user.endOfDayReminderEnabled) {
      await _scheduleDailyReminder(
        id: _endOfDayId,
        time: user.endOfDayReminderTime,
        title: '오늘 하루 정리',
        body: '오늘 먹은 음식을 모두 기록하셨나요? 📝',
      );
    }

    debugPrint('NotificationService: All reminders scheduled');
  }

  /// Schedule a daily repeating notification at the specified time
  Future<void> _scheduleDailyReminder({
    required int id,
    required String time,
    required String title,
    required String body,
  }) async {
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    final scheduledTime = _nextInstanceOfTime(hour, minute);

    const androidDetails = AndroidNotificationDetails(
      'meal_reminders',
      'Meal Reminders',
      channelDescription: 'Reminders to log your meals',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      payload: 'meal_reminder_$id',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint(
        'NotificationService: Scheduled reminder $id at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
  }

  /// Get the next instance of the specified time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Cancel all scheduled reminders
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
    debugPrint('NotificationService: Cancelled all reminders');
  }

  /// Cancel a specific reminder by ID
  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
    debugPrint('NotificationService: Cancelled reminder $id');
  }

  /// Show an immediate notification (for testing)
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'For testing notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      '테스트 알림',
      '알림이 정상적으로 작동합니다! 🎉',
      details,
    );
  }

  /// Get pending notification requests (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
