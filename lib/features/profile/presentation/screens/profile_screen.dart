import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final userGoalsAsync = ref.watch(userGoalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.profile,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        // TODO: Navigate to settings
                      },
                    ),
                  ],
                ),
              ),

              // Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
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
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? l10n.defaultUserEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
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

              // Settings Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settings,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: l10n.notifications,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.language,
                      label: l10n.language,
                      trailing: l10n.english,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.straighten,
                      label: l10n.units,
                      trailing: l10n.imperial,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      label: l10n.darkMode,
                      trailing: l10n.off,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.security_outlined,
                      label: l10n.privacy,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      label: l10n.helpAndSupport,
                      onTap: () {},
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: Icons.star_outline,
                      label: l10n.rateApp,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.share_outlined,
                      label: l10n.shareApp,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      label: l10n.about,
                      trailing: 'v${AppConstants.appVersion}',
                      onTap: () {},
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

  void _showSignOutDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmMessage),
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
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
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
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
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
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
