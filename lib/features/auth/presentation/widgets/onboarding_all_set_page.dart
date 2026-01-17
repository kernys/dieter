import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/onboarding_provider.dart';

class OnboardingAllSetPage extends ConsumerWidget {
  const OnboardingAllSetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          // Success icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 60,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'You\'re all set!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your personalized plan is ready.\nLet\'s start your journey!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
          // Summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Daily Goals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGoalRow(
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                  label: 'Calories',
                  value: '${onboardingState.dailyCalorieGoal} cal',
                ),
                const SizedBox(height: 12),
                _buildGoalRow(
                  icon: Icons.egg_alt,
                  color: AppColors.protein,
                  label: 'Protein',
                  value: '${onboardingState.dailyProteinGoal}g',
                ),
                const SizedBox(height: 12),
                _buildGoalRow(
                  icon: Icons.grain,
                  color: AppColors.carbs,
                  label: 'Carbs',
                  value: '${onboardingState.dailyCarbsGoal}g',
                ),
                const SizedBox(height: 12),
                _buildGoalRow(
                  icon: Icons.water_drop,
                  color: AppColors.fat,
                  label: 'Fat',
                  value: '${onboardingState.dailyFatGoal}g',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Goal weight info
          if (onboardingState.goalWeight != null &&
              onboardingState.currentWeight != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _getGoalIcon(onboardingState),
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getGoalMessage(onboardingState),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildGoalRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  IconData _getGoalIcon(OnboardingState state) {
    final isMetric = state.unitSystem == UnitSystem.metric;

    double goalWeight = state.goalWeight!;
    double currentWeight;

    if (isMetric) {
      currentWeight = state.currentWeightKg ?? state.currentWeight! * 0.453592;
    } else {
      currentWeight = state.currentWeight!;
    }

    if (goalWeight < currentWeight) {
      return Icons.trending_down;
    } else if (goalWeight > currentWeight) {
      return Icons.trending_up;
    }
    return Icons.trending_flat;
  }

  String _getGoalMessage(OnboardingState state) {
    final isMetric = state.unitSystem == UnitSystem.metric;
    final unit = isMetric ? 'kg' : 'lbs';

    double goalWeight;
    double currentWeight;

    if (isMetric) {
      // goalWeight in metric is stored directly, currentWeight uses currentWeightKg
      goalWeight = state.goalWeight!;
      currentWeight = state.currentWeightKg ?? state.currentWeight! * 0.453592;
    } else {
      goalWeight = state.goalWeight!;
      currentWeight = state.currentWeight!;
    }

    final diff = (goalWeight - currentWeight).abs();

    if (goalWeight < currentWeight) {
      return 'Goal: Lose ${diff.toStringAsFixed(0)} $unit to reach ${goalWeight.toStringAsFixed(0)} $unit';
    } else if (goalWeight > currentWeight) {
      return 'Goal: Gain ${diff.toStringAsFixed(0)} $unit to reach ${goalWeight.toStringAsFixed(0)} $unit';
    }
    return 'Goal: Maintain your current weight of ${currentWeight.toStringAsFixed(0)} $unit';
  }
}
