import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/onboarding_provider.dart';

class OnboardingDailyRecommendationPage extends ConsumerStatefulWidget {
  const OnboardingDailyRecommendationPage({super.key});

  @override
  ConsumerState<OnboardingDailyRecommendationPage> createState() =>
      _OnboardingDailyRecommendationPageState();
}

class _OnboardingDailyRecommendationPageState
    extends ConsumerState<OnboardingDailyRecommendationPage> {
  int _calories = 1054;
  int _carbs = 95;
  int _protein = 101;
  int _fats = 29;

  @override
  void initState() {
    super.initState();
    _calculateRecommendations();
  }

  void _calculateRecommendations() {
    final onboardingState = ref.read(onboardingProvider);

    // Calculate BMR based on user data
    double bmr = 1500; // Default

    if (onboardingState.currentWeight != null &&
        onboardingState.totalHeightCm != null &&
        onboardingState.birthDate != null) {
      final weight = onboardingState.unitSystem == UnitSystem.imperial
          ? onboardingState.currentWeight! * 0.453592
          : onboardingState.currentWeight!;
      final height = onboardingState.totalHeightCm!;
      final age =
          DateTime.now().difference(onboardingState.birthDate!).inDays ~/ 365;

      // Mifflin-St Jeor Equation (assuming male, can be adjusted)
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    }

    // Apply activity factor (sedentary = 1.2)
    final tdee = bmr * 1.2;

    // If goal is to lose weight, create a deficit
    final goalWeight = onboardingState.goalWeight;
    final currentWeight = onboardingState.currentWeight;

    double targetCalories = tdee;
    if (goalWeight != null && currentWeight != null) {
      if (goalWeight < currentWeight) {
        targetCalories = tdee - 500; // 500 calorie deficit
      } else if (goalWeight > currentWeight) {
        targetCalories = tdee + 300; // 300 calorie surplus
      }
    }

    setState(() {
      _calories = targetCalories.round().clamp(1200, 4000);
      // Macro distribution: 40% carbs, 30% protein, 30% fat
      _carbs = ((_calories * 0.40) / 4).round(); // 4 cal per gram
      _protein = ((_calories * 0.30) / 4).round(); // 4 cal per gram
      _fats = ((_calories * 0.30) / 9).round(); // 9 cal per gram
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Daily recommendation',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You can edit this anytime',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 40),

          // Macro cards grid
          Row(
            children: [
              Expanded(
                child: _MacroCard(
                  icon: Icons.local_fire_department,
                  iconColor: AppColors.textPrimary,
                  label: 'Calories',
                  value: _calories,
                  unit: '',
                  progress: 1.0,
                  progressColor: AppColors.textPrimary,
                  onEdit: () => _editMacro('Calories', _calories, (v) {
                    setState(() => _calories = v);
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MacroCard(
                  icon: Icons.grain,
                  iconColor: AppColors.carbs,
                  label: 'Carbs',
                  value: _carbs,
                  unit: 'g',
                  progress: 0.7,
                  progressColor: AppColors.carbs,
                  onEdit: () => _editMacro('Carbs', _carbs, (v) {
                    setState(() => _carbs = v);
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MacroCard(
                  icon: Icons.egg_alt,
                  iconColor: AppColors.protein,
                  label: 'Protein',
                  value: _protein,
                  unit: 'g',
                  progress: 0.8,
                  progressColor: AppColors.protein,
                  onEdit: () => _editMacro('Protein', _protein, (v) {
                    setState(() => _protein = v);
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MacroCard(
                  icon: Icons.water_drop,
                  iconColor: AppColors.fat,
                  label: 'Fats',
                  value: _fats,
                  unit: 'g',
                  progress: 0.5,
                  progressColor: AppColors.fat,
                  onEdit: () => _editMacro('Fats', _fats, (v) {
                    setState(() => _fats = v);
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Health Score card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.pink.shade300,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health Score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: AppColors.progressBackground,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 6,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '7/10',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          const Text(
            'How to reach your goals:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTip(
            Icons.restaurant,
            'Track your meals consistently',
          ),
          const SizedBox(height: 12),
          _buildTip(
            Icons.directions_walk,
            'Stay active with 10,000 steps daily',
          ),
          const SizedBox(height: 12),
          _buildTip(
            Icons.local_drink,
            'Drink 8 glasses of water per day',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  void _editMacro(String label, int currentValue, ValueChanged<int> onChanged) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MacroEditSheet(
        label: label,
        currentValue: currentValue,
        onSave: (value) {
          onChanged(value);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final int value;
  final String unit;
  final double progress;
  final Color progressColor;
  final VoidCallback onEdit;

  const _MacroCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.progressColor,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Circular progress
              SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: AppColors.progressBackground,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$value',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: unit,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroEditSheet extends StatefulWidget {
  final String label;
  final int currentValue;
  final ValueChanged<int> onSave;

  const _MacroEditSheet({
    required this.label,
    required this.currentValue,
    required this.onSave,
  });

  @override
  State<_MacroEditSheet> createState() => _MacroEditSheetState();
}

class _MacroEditSheetState extends State<_MacroEditSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit ${widget.label}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              suffixText: widget.label == 'Calories' ? 'cal' : 'g',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final value = int.tryParse(_controller.text);
                if (value != null) {
                  widget.onSave(value);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
