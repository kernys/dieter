import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Goal settings
  int _calorieGoal = AppConstants.defaultCalorieGoal;
  int _proteinGoal = AppConstants.defaultProteinGoal;
  int _carbsGoal = AppConstants.defaultCarbsGoal;
  int _fatGoal = AppConstants.defaultFatGoal;
  double? _currentWeight;
  double? _goalWeight;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      final updates = <String, dynamic>{
        'daily_calorie_goal': _calorieGoal,
        'daily_protein_goal': _proteinGoal,
        'daily_carbs_goal': _carbsGoal,
        'daily_fat_goal': _fatGoal,
      };

      if (_currentWeight != null) {
        updates['current_weight'] = _currentWeight;
      }
      if (_goalWeight != null) {
        updates['goal_weight'] = _goalWeight;
      }

      await ref.read(authStateProvider.notifier).updateUser(updates);
    } catch (e) {
      // Continue even if saving fails - user can update later
      debugPrint('Failed to save onboarding settings: $e');
    }

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppColors.primary
                            : AppColors.progressBackground,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _buildWelcomePage(),
                  _buildGoalsPage(),
                  _buildWeightPage(),
                ],
              ),
            ),

            // Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: _currentPage > 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(_currentPage < 2 ? 'Continue' : 'Get Started'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Track calories with AI',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Simply take a photo of your food and our AI will instantly analyze the nutritional content',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Set your daily goals',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You can adjust these anytime in settings',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Calories
          _GoalSlider(
            label: 'Daily Calories',
            value: _calorieGoal.toDouble(),
            min: 1200,
            max: 4000,
            unit: 'cal',
            color: AppColors.calories,
            onChanged: (value) {
              setState(() => _calorieGoal = value.toInt());
            },
          ),
          const SizedBox(height: 24),

          // Protein
          _GoalSlider(
            label: 'Protein',
            value: _proteinGoal.toDouble(),
            min: 50,
            max: 300,
            unit: 'g',
            color: AppColors.protein,
            onChanged: (value) {
              setState(() => _proteinGoal = value.toInt());
            },
          ),
          const SizedBox(height: 24),

          // Carbs
          _GoalSlider(
            label: 'Carbohydrates',
            value: _carbsGoal.toDouble(),
            min: 100,
            max: 500,
            unit: 'g',
            color: AppColors.carbs,
            onChanged: (value) {
              setState(() => _carbsGoal = value.toInt());
            },
          ),
          const SizedBox(height: 24),

          // Fat
          _GoalSlider(
            label: 'Fat',
            value: _fatGoal.toDouble(),
            min: 30,
            max: 150,
            unit: 'g',
            color: AppColors.fat,
            onChanged: (value) {
              setState(() => _fatGoal = value.toInt());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeightPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Track your weight',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Optional: Set your weight goals',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Current Weight
          const Text(
            'Current Weight',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _currentWeight?.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Enter your weight',
              suffixText: 'lbs',
            ),
            onChanged: (value) {
              setState(() {
                _currentWeight = double.tryParse(value);
              });
            },
          ),
          const SizedBox(height: 24),

          // Goal Weight
          const Text(
            'Goal Weight',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _goalWeight?.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Enter your goal weight',
              suffixText: 'lbs',
            ),
            onChanged: (value) {
              setState(() {
                _goalWeight = double.tryParse(value);
              });
            },
          ),
          const SizedBox(height: 40),

          // Skip option
          Center(
            child: TextButton(
              onPressed: _completeOnboarding,
              child: const Text(
                'Skip for now',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final Color color;
  final ValueChanged<double> onChanged;

  const _GoalSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toInt()} $unit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
