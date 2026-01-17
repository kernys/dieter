import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/onboarding_provider.dart';

class OnboardingGenderPage extends ConsumerStatefulWidget {
  const OnboardingGenderPage({super.key});

  @override
  ConsumerState<OnboardingGenderPage> createState() =>
      _OnboardingGenderPageState();
}

class _OnboardingGenderPageState extends ConsumerState<OnboardingGenderPage> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingProvider);
    _selectedGender = onboardingState.gender;
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    ref.read(onboardingProvider.notifier).setGender(gender);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'What is your\nbiological sex?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps us calculate your daily\ncalorie and nutrition needs.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const Spacer(),
          // Gender options
          Row(
            children: [
              Expanded(
                child: _GenderOption(
                  icon: Icons.male,
                  label: 'Male',
                  isSelected: _selectedGender == 'male',
                  onTap: () => _selectGender('male'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _GenderOption(
                  icon: Icons.female,
                  label: 'Female',
                  isSelected: _selectedGender == 'female',
                  onTap: () => _selectGender('female'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Prefer not to say option
          _GenderOption(
            icon: Icons.person_outline,
            label: 'Prefer not to say',
            isSelected: _selectedGender == 'other',
            onTap: () => _selectGender('other'),
            isFullWidth: true,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFullWidth;

  const _GenderOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: isFullWidth ? 16 : 32,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: isFullWidth
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
