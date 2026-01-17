import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_birth_date_page.dart';
import '../widgets/onboarding_goal_weight_page.dart';
import '../widgets/onboarding_height_weight_page.dart';
import '../widgets/onboarding_daily_recommendation_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  static const int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onContinue() {
    final currentStep = ref.read(onboardingProvider).currentStep;
    if (currentStep < _totalPages - 1) {
      ref.read(onboardingProvider.notifier).nextStep();
      _goToPage(currentStep + 1);
    } else {
      _completeOnboarding();
    }
  }

  void _onBack() {
    final currentStep = ref.read(onboardingProvider).currentStep;
    if (currentStep > 0) {
      ref.read(onboardingProvider.notifier).previousStep();
      _goToPage(currentStep - 1);
    }
  }

  Future<void> _completeOnboarding() async {
    final onboardingState = ref.read(onboardingProvider);

    try {
      final updates = <String, dynamic>{};

      if (onboardingState.birthDate != null) {
        updates['birth_date'] = onboardingState.birthDate!.toIso8601String();
      }

      if (onboardingState.goalWeight != null) {
        updates['goal_weight'] = onboardingState.goalWeight;
      }

      if (onboardingState.heightFeet != null) {
        updates['height_feet'] = onboardingState.heightFeet;
      }

      if (onboardingState.heightInches != null) {
        updates['height_inches'] = onboardingState.heightInches;
      }

      if (onboardingState.heightCm != null) {
        updates['height_cm'] = onboardingState.heightCm;
      }

      if (onboardingState.currentWeight != null) {
        updates['current_weight'] = onboardingState.currentWeight;
      }

      if (onboardingState.gender != null) {
        updates['gender'] = onboardingState.gender;
      }

      updates['daily_calorie_goal'] = onboardingState.dailyCalorieGoal;
      updates['daily_protein_goal'] = onboardingState.dailyProteinGoal;
      updates['daily_carbs_goal'] = onboardingState.dailyCarbsGoal;
      updates['daily_fat_goal'] = onboardingState.dailyFatGoal;
      updates['onboarding_completed'] = true;

      await ref.read(authStateProvider.notifier).updateUser(updates);
      await ref.read(onboardingProvider.notifier).completeOnboarding();
    } catch (e) {
      debugPrint('Failed to save onboarding settings: $e');
      // Continue anyway - user can update later
      await ref.read(onboardingProvider.notifier).completeOnboarding();
    }

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(onboardingProvider).currentStep;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Back button
                  if (currentStep > 0)
                    GestureDetector(
                      onTap: _onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 40),
                  const SizedBox(width: 16),
                  // Progress indicator
                  Expanded(
                    child: Row(
                      children: List.generate(_totalPages, (index) {
                        final isActive = index <= currentStep;
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: index < _totalPages - 1 ? 8 : 0,
                            ),
                            height: 4,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.progressBackground,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  ref.read(onboardingProvider.notifier).goToStep(page);
                },
                children: const [
                  OnboardingBirthDatePage(),
                  OnboardingHeightWeightPage(),
                  OnboardingGoalWeightPage(),
                  OnboardingDailyRecommendationPage(),
                ],
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    currentStep == _totalPages - 1 ? "Let's get started!" : 'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
