import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
    final userGoalsAsync = ref.watch(userGoalsProvider);
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

              // Daily Goals Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: userGoalsAsync.when(
                  data: (goals) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyGoals,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _GoalTile(
                        icon: Icons.local_fire_department,
                        label: l10n.calories,
                        value: '${goals.calorieGoal} ${l10n.cal}',
                        color: AppColors.calories,
                        onTap: () => _showEditGoalDialog(context, ref, l10n, 'calories', goals.calorieGoal),
                      ),
                      _GoalTile(
                        icon: Icons.egg_outlined,
                        label: l10n.protein,
                        value: '${goals.proteinGoal}g',
                        color: AppColors.protein,
                        onTap: () => _showEditGoalDialog(context, ref, l10n, 'protein', goals.proteinGoal),
                      ),
                      _GoalTile(
                        icon: Icons.grass,
                        label: l10n.carbohydrates,
                        value: '${goals.carbsGoal}g',
                        color: AppColors.carbs,
                        onTap: () => _showEditGoalDialog(context, ref, l10n, 'carbs', goals.carbsGoal),
                      ),
                      _GoalTile(
                        icon: Icons.water_drop_outlined,
                        label: l10n.fat,
                        value: '${goals.fatGoal}g',
                        color: AppColors.fat,
                        onTap: () => _showEditGoalDialog(context, ref, l10n, 'fat', goals.fatGoal),
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyGoals,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _GoalTile(
                        icon: Icons.local_fire_department,
                        label: l10n.calories,
                        value: '${AppConstants.defaultCalorieGoal} ${l10n.cal}',
                        color: AppColors.calories,
                      ),
                      _GoalTile(
                        icon: Icons.egg_outlined,
                        label: l10n.protein,
                        value: '${AppConstants.defaultProteinGoal}g',
                        color: AppColors.protein,
                      ),
                      _GoalTile(
                        icon: Icons.grass,
                        label: l10n.carbohydrates,
                        value: '${AppConstants.defaultCarbsGoal}g',
                        color: AppColors.carbs,
                      ),
                      _GoalTile(
                        icon: Icons.water_drop_outlined,
                        label: l10n.fat,
                        value: '${AppConstants.defaultFatGoal}g',
                        color: AppColors.fat,
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
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: l10n.notifications,
                      onTap: () => _showNotificationsDialog(context, ref, l10n, settings),
                    ),
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

  void _showEditGoalDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, String goalType, int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());

    String title;
    switch (goalType) {
      case 'calories':
        title = l10n.calories;
        break;
      case 'protein':
        title = l10n.protein;
        break;
      case 'carbs':
        title = l10n.carbohydrates;
        break;
      case 'fat':
        title = l10n.fat;
        break;
      default:
        title = goalType;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: goalType == 'calories' ? l10n.cal : 'g',
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                try {
                  String fieldName;
                  switch (goalType) {
                    case 'calories':
                      fieldName = 'daily_calorie_goal';
                      break;
                    case 'protein':
                      fieldName = 'daily_protein_goal';
                      break;
                    case 'carbs':
                      fieldName = 'daily_carbs_goal';
                      break;
                    case 'fat':
                      fieldName = 'daily_fat_goal';
                      break;
                    default:
                      fieldName = goalType;
                  }

                  await ref.read(authStateProvider.notifier).updateUser({
                    fieldName: value,
                  });

                  ref.invalidate(userGoalsProvider);

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

  void _showNotificationsDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppSettings settings,
  ) {
    // Use local state for the dialog to reflect immediate updates
    bool mealReminders = settings.mealReminders;
    bool weightReminders = settings.weightReminders;
    bool weeklyReports = settings.weeklyReports;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.notifications),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text(l10n.mealReminders),
                  subtitle: Text(l10n.mealRemindersDescription),
                  value: mealReminders,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setMealReminders(value);
                    setState(() {
                      mealReminders = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.weightReminders),
                  subtitle: Text(l10n.weightRemindersDescription),
                  value: weightReminders,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setWeightReminders(value);
                    setState(() {
                      weightReminders = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.weeklyReports),
                  subtitle: Text(l10n.weeklyReportsDescription),
                  value: weeklyReports,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setWeeklyReports(value);
                    setState(() {
                      weeklyReports = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.done),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _GoalTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
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
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
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
