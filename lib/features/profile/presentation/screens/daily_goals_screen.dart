import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';

class DailyGoalsScreen extends ConsumerWidget {
  const DailyGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userGoalsAsync = ref.watch(userGoalsProvider);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.dailyGoals,
          style: TextStyle(
            color: context.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: userGoalsAsync.when(
        data: (goals) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.dailyGoalsDescription,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Calories Goal
            _GoalCard(
              icon: Icons.local_fire_department,
              label: l10n.calories,
              value: goals.calorieGoal,
              unit: l10n.cal,
              color: AppColors.calories,
              onTap: () => _showEditGoalDialog(
                context, ref, l10n, 'calories', goals.calorieGoal,
              ),
            ),
            const SizedBox(height: 12),

            // Protein Goal
            _GoalCard(
              icon: Icons.egg_outlined,
              label: l10n.protein,
              value: goals.proteinGoal,
              unit: 'g',
              color: AppColors.protein,
              onTap: () => _showEditGoalDialog(
                context, ref, l10n, 'protein', goals.proteinGoal,
              ),
            ),
            const SizedBox(height: 12),

            // Carbs Goal
            _GoalCard(
              icon: Icons.grass,
              label: l10n.carbohydrates,
              value: goals.carbsGoal,
              unit: 'g',
              color: AppColors.carbs,
              onTap: () => _showEditGoalDialog(
                context, ref, l10n, 'carbs', goals.carbsGoal,
              ),
            ),
            const SizedBox(height: 12),

            // Fat Goal
            _GoalCard(
              icon: Icons.water_drop_outlined,
              label: l10n.fat,
              value: goals.fatGoal,
              unit: 'g',
              color: AppColors.fat,
              onTap: () => _showEditGoalDialog(
                context, ref, l10n, 'fat', goals.fatGoal,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _GoalCard(
              icon: Icons.local_fire_department,
              label: l10n.calories,
              value: AppConstants.defaultCalorieGoal,
              unit: l10n.cal,
              color: AppColors.calories,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _GoalCard(
              icon: Icons.egg_outlined,
              label: l10n.protein,
              value: AppConstants.defaultProteinGoal,
              unit: 'g',
              color: AppColors.protein,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _GoalCard(
              icon: Icons.grass,
              label: l10n.carbohydrates,
              value: AppConstants.defaultCarbsGoal,
              unit: 'g',
              color: AppColors.carbs,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _GoalCard(
              icon: Icons.water_drop_outlined,
              label: l10n.fat,
              value: AppConstants.defaultFatGoal,
              unit: 'g',
              color: AppColors.fat,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGoalDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String goalType,
    int currentValue,
  ) {
    final controller = TextEditingController(text: currentValue.toString());

    String title;
    String unit;
    switch (goalType) {
      case 'calories':
        title = l10n.calories;
        unit = l10n.cal;
        break;
      case 'protein':
        title = l10n.protein;
        unit = 'g';
        break;
      case 'carbs':
        title = l10n.carbohydrates;
        unit = 'g';
        break;
      case 'fat':
        title = l10n.fat;
        unit = 'g';
        break;
      default:
        title = goalType;
        unit = '';
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            suffixText: unit,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
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
                      fieldName = 'dailyCalorieGoal';
                      break;
                    case 'protein':
                      fieldName = 'dailyProteinGoal';
                      break;
                    case 'carbs':
                      fieldName = 'dailyCarbsGoal';
                      break;
                    case 'fat':
                      fieldName = 'dailyFatGoal';
                      break;
                    default:
                      fieldName = goalType;
                  }

                  await ref.read(authStateProvider.notifier).updateUser({
                    fieldName: value,
                  });

                  ref.invalidate(userGoalsProvider);

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
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

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final String unit;
  final Color color;
  final VoidCallback onTap;

  const _GoalCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$value',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit_outlined,
              color: context.textTertiaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
