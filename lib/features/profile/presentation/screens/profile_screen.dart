import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
// import '../../../../services/health_service.dart'; // TODO: Temporarily disabled
import '../../../../services/live_activity_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../providers/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.profile,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimaryColor,
                    ),
                  ),
                ),
              ),

              // Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(user?.name ?? l10n.defaultUserName),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? l10n.defaultUserName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? l10n.defaultUserEmail,
                              style: TextStyle(
                                fontSize: 14,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showEditProfileDialog(context, ref, l10n, user);
                        },
                        child: Text(l10n.edit),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Goals & Tracking Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.goalsAndTracking,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: Icons.track_changes,
                      label: l10n.dailyGoals,
                      onTap: () {
                        context.push('/daily-goals');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.person_outline,
                      label: l10n.personalDetails,
                      onTap: () {
                        context.push('/personal-details');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.history,
                      label: l10n.weightHistory,
                      onTap: () {
                        context.push('/weight-history');
                      },
                    ),
                    // TODO: Apple Health / Health Connect - temporarily disabled
                    // _HealthTile(
                    //   label: Platform.isIOS ? l10n.appleHealth : l10n.healthConnect,
                    //   onTap: () async {
                    //     final healthService = ref.read(healthServiceProvider);
                    //     final success = await healthService.requestAuthorization();
                    //     if (context.mounted) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //           content: Text(
                    //             success ? l10n.healthConnected : l10n.healthConnectionFailed,
                    //           ),
                    //           backgroundColor: success ? Colors.green : null,
                    //         ),
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settings,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // TODO: Badges - temporarily hidden
                    // _SettingsTile(
                    //   icon: Icons.emoji_events_outlined,
                    //   label: l10n.badges,
                    //   onTap: () => context.push('/badges'),
                    // ),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: l10n.notifications,
                      onTap: () => context.push('/notification-settings'),
                    ),
                    // Live Activity toggle (iOS only)
                    if (Platform.isIOS)
                      _LiveActivityTile(l10n: l10n),
                    _SettingsTile(
                      icon: Icons.language,
                      label: l10n.language,
                      trailing: settings.locale == 'ko' ? l10n.korean : l10n.english,
                      onTap: () => _showLanguageDialog(context, ref, l10n, settings),
                    ),
                    _SettingsTile(
                      icon: Icons.straighten,
                      label: l10n.units,
                      trailing: settings.unitSystem == UnitSystem.metric ? l10n.metric : l10n.imperial,
                      onTap: () => _showUnitsDialog(context, ref, l10n, settings),
                    ),
                    _SettingsTile(
                      icon: Icons.security_outlined,
                      label: l10n.privacy,
                      onTap: () {
                        context.push('/privacy');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      label: l10n.helpAndSupport,
                      onTap: () {
                        _sendSupportEmail(context, l10n);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // App Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.app,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AppInfoTile(
                      icon: Icons.info_outline,
                      label: l10n.about,
                      version: 'v${AppConstants.appVersion}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sign Out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _showSignOutDialog(context, ref, l10n);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: Text(l10n.signOut),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _sendSupportEmail(BuildContext context, AppLocalizations l10n) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'kernys01@gmail.com',
      query: 'subject=Diet AI Support',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('kernys01@gmail.com')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('kernys01@gmail.com')),
        );
      }
    }
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmMessage),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              Navigator.pop(context);
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, dynamic user) {
    final nameController = TextEditingController(text: user?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.edit),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: l10n.name),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                try {
                  await ref.read(authStateProvider.notifier).updateUser({
                    'name': nameController.text,
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.failedToSave(e.toString()))),
                    );
                  }
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: settings.locale,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.korean),
              value: 'ko',
              groupValue: settings.locale,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showUnitsDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.units),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<UnitSystem>(
              title: Text(l10n.imperial),
              subtitle: const Text('lbs, ft'),
              value: UnitSystem.imperial,
              groupValue: settings.unitSystem,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setUnitSystem(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<UnitSystem>(
              title: Text(l10n.metric),
              subtitle: const Text('kg, cm'),
              value: UnitSystem.metric,
              groupValue: settings.unitSystem,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setUnitSystem(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.textSecondaryColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimaryColor,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textSecondaryColor,
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: context.textTertiaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveActivityTile extends ConsumerStatefulWidget {
  final AppLocalizations l10n;

  const _LiveActivityTile({required this.l10n});

  @override
  ConsumerState<_LiveActivityTile> createState() => _LiveActivityTileState();
}

class _LiveActivityTileState extends ConsumerState<_LiveActivityTile> {
  bool _isEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final liveActivityService = ref.read(liveActivityServiceProvider);
    final enabled = await liveActivityService.isEnabled();
    if (mounted) {
      setState(() {
        _isEnabled = enabled;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLiveActivity(bool value) async {
    setState(() => _isLoading = true);
    
    final liveActivityService = ref.read(liveActivityServiceProvider);
    
    // Check if supported first
    if (value) {
      final isSupported = await liveActivityService.checkSupport();
      if (!isSupported) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.l10n.liveActivityNotSupported)),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      
      // Enable Live Activity - actual activity will be created by home_provider
      await liveActivityService.setEnabled(true);
      
      // Get current data to start with
      final today = DateTime.now();
      final todayNormalized = DateTime(today.year, today.month, today.day);
      final summaryAsync = ref.read(dailySummaryProvider(todayNormalized));
      final goalsAsync = ref.read(userGoalsProvider);
      
      int caloriesLeft = 2000;
      int caloriesGoal = 2000;
      int caloriesConsumed = 0;
      int proteinLeft = 100;
      int carbsLeft = 250;
      int fatLeft = 65;
      
      // Synchronously extract data if available
      final summaryValue = summaryAsync.valueOrNull;
      final goalsValue = goalsAsync.valueOrNull;
      
      if (summaryValue != null && goalsValue != null) {
        caloriesConsumed = summaryValue.totalCalories;
        caloriesGoal = goalsValue.calorieGoal;
        caloriesLeft = (goalsValue.calorieGoal - caloriesConsumed).clamp(0, goalsValue.calorieGoal);
        proteinLeft = (goalsValue.proteinGoal - summaryValue.totalProtein).clamp(0.0, goalsValue.proteinGoal.toDouble()).toInt();
        carbsLeft = (goalsValue.carbsGoal - summaryValue.totalCarbs).clamp(0.0, goalsValue.carbsGoal.toDouble()).toInt();
        fatLeft = (goalsValue.fatGoal - summaryValue.totalFat).clamp(0.0, goalsValue.fatGoal.toDouble()).toInt();
      }
      
      // Create initial activity with current data
      await liveActivityService.createOrUpdateActivity(
        caloriesLeft: caloriesLeft,
        caloriesGoal: caloriesGoal,
        caloriesConsumed: caloriesConsumed,
        proteinLeft: proteinLeft,
        carbsLeft: carbsLeft,
        fatLeft: fatLeft,
      );
    } else {
      await liveActivityService.setEnabled(false);
    }
    
    ref.read(liveActivityEnabledProvider.notifier).state = value;
    
    if (mounted) {
      setState(() {
        _isEnabled = value;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: context.textSecondaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.l10n.liveActivity,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.l10n.liveActivityDescription,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Switch.adaptive(
              value: _isEnabled,
              onChanged: _toggleLiveActivity,
              activeColor: AppColors.primary,
            ),
        ],
      ),
    );
  }
}

class _AppInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String version;

  const _AppInfoTile({
    required this.icon,
    required this.label,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.textSecondaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          Text(
            version,
            style: TextStyle(
              fontSize: 14,
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: _HealthTile - Temporarily disabled
// class _HealthTile extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
// 
//   const _HealthTile({
//     required this.label,
//     required this.onTap,
//   });
// 
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: context.cardColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: context.borderColor),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.favorite,
//                   color: Color(0xFFFF2D55),
//                   size: 20,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: context.textPrimaryColor,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               color: context.textTertiaryColor,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
