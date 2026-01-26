import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _notificationsEnabled = status.isGranted;
      _isCheckingPermission = false;
    });
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: _buildAppBar(l10n),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: _buildAppBar(l10n),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Permission Banner
            if (!_isCheckingPermission && !_notificationsEnabled)
              _buildPermissionBanner(l10n),

            const SizedBox(height: 24),

            // Tracking Reminders Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.trackingReminders,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Meal Reminders Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  children: [
                    _ReminderTile(
                      label: l10n.breakfast,
                      time: user.breakfastReminderTime,
                      enabled: user.breakfastReminderEnabled,
                      onToggle: (value) => _updateReminder(
                        'breakfastReminderEnabled',
                        value,
                      ),
                      onTimeChange: () => _showTimePicker(
                        l10n.breakfast,
                        user.breakfastReminderTime,
                        'breakfastReminderTime',
                      ),
                    ),
                    Divider(height: 1, color: context.borderColor),
                    _ReminderTile(
                      label: l10n.lunch,
                      time: user.lunchReminderTime,
                      enabled: user.lunchReminderEnabled,
                      onToggle: (value) => _updateReminder(
                        'lunchReminderEnabled',
                        value,
                      ),
                      onTimeChange: () => _showTimePicker(
                        l10n.lunch,
                        user.lunchReminderTime,
                        'lunchReminderTime',
                      ),
                    ),
                    Divider(height: 1, color: context.borderColor),
                    _ReminderTile(
                      label: l10n.snack,
                      time: user.snackReminderTime,
                      enabled: user.snackReminderEnabled,
                      onToggle: (value) => _updateReminder(
                        'snackReminderEnabled',
                        value,
                      ),
                      onTimeChange: () => _showTimePicker(
                        l10n.snack,
                        user.snackReminderTime,
                        'snackReminderTime',
                      ),
                    ),
                    Divider(height: 1, color: context.borderColor),
                    _ReminderTile(
                      label: l10n.dinner,
                      time: user.dinnerReminderTime,
                      enabled: user.dinnerReminderEnabled,
                      onToggle: (value) => _updateReminder(
                        'dinnerReminderEnabled',
                        value,
                      ),
                      onTimeChange: () => _showTimePicker(
                        l10n.dinner,
                        user.dinnerReminderTime,
                        'dinnerReminderTime',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // End of Day Reminder Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.endOfDay,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: context.textPrimaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showTimePicker(
                            l10n.endOfDay,
                            user.endOfDayReminderTime,
                            'endOfDayReminderTime',
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: context.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatTime(user.endOfDayReminderTime),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.textPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Switch.adaptive(
                          value: user.endOfDayReminderEnabled,
                          onChanged: (value) => _updateReminder(
                            'endOfDayReminderEnabled',
                            value,
                          ),
                          activeTrackColor: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.endOfDayDescription,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Debug section - only in debug mode
            if (kDebugMode) ...[
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Debug',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Test Notification',
                          style: TextStyle(color: context.textPrimaryColor),
                        ),
                        subtitle: Text(
                          'Send a test notification now',
                          style: TextStyle(color: context.textSecondaryColor),
                        ),
                        trailing: Icon(Icons.send, color: context.textSecondaryColor),
                        onTap: () async {
                          final notificationService = ref.read(notificationServiceProvider);
                          await notificationService.showTestNotification();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Test notification sent!')),
                            );
                          }
                        },
                      ),
                      Divider(height: 1, color: context.borderColor),
                      ListTile(
                        title: Text(
                          'View Pending Notifications',
                          style: TextStyle(color: context.textPrimaryColor),
                        ),
                        subtitle: Text(
                          'Show scheduled notifications',
                          style: TextStyle(color: context.textSecondaryColor),
                        ),
                        trailing: Icon(Icons.schedule, color: context.textSecondaryColor),
                        onTap: () async {
                          final notificationService = ref.read(notificationServiceProvider);
                          final pending = await notificationService.getPendingNotifications();
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Pending Notifications'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: pending.isEmpty
                                      ? const Text('No scheduled notifications')
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: pending.length,
                                          itemBuilder: (context, index) {
                                            final n = pending[index];
                                            return ListTile(
                                              title: Text(n.title ?? 'No title'),
                                              subtitle: Text('ID: ${n.id}'),
                                            );
                                          },
                                        ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: context.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.cardColor,
          ),
          child: Icon(
            Icons.arrow_back,
            color: context.textPrimaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionBanner(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationsDisabledMessage,
              style: TextStyle(
                fontSize: 14,
                color: context.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _openAppSettings,
              child: Row(
                children: [
                  Text(
                    l10n.openSettings,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateReminder(String field, bool value) {
    ref.read(authStateProvider.notifier).updateUser({field: value});
  }

  void _showTimePicker(String title, String currentTime, String field) {
    final parts = currentTime.split(':');
    int hour = int.tryParse(parts[0]) ?? 8;
    int minute = int.tryParse(parts[1]) ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _TimePickerSheet(
          title: title,
          initialHour: hour,
          initialMinute: minute,
          onSave: (selectedHour, selectedMinute) {
            final timeString =
                '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
            ref.read(authStateProvider.notifier).updateUser({field: timeString});
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? parts[1] : '00';
    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute $period';
  }
}

class _ReminderTile extends StatelessWidget {
  final String label;
  final String time;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTimeChange;

  const _ReminderTile({
    required this.label,
    required this.time,
    required this.enabled,
    required this.onToggle,
    required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTimeChange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTime(time),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: enabled,
            onChanged: onToggle,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? parts[1] : '00';
    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute $period';
  }
}

class _TimePickerSheet extends StatefulWidget {
  final String title;
  final int initialHour;
  final int initialMinute;
  final Function(int hour, int minute) onSave;

  const _TimePickerSheet({
    required this.title,
    required this.initialHour,
    required this.initialMinute,
    required this.onSave,
  });

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialHour;
    _selectedMinute = widget.initialMinute;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime(
                2024,
                1,
                1,
                _selectedHour,
                _selectedMinute,
              ),
              onDateTimeChanged: (DateTime newTime) {
                setState(() {
                  _selectedHour = newTime.hour;
                  _selectedMinute = newTime.minute;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => widget.onSave(_selectedHour, _selectedMinute),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}
