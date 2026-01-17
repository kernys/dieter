import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UnitSystem { imperial, metric }

class OnboardingState {
  final int currentStep;
  final DateTime? birthDate;
  final double? goalWeight;
  final int? heightFeet;
  final int? heightInches;
  final double? heightCm;
  final double? currentWeight;
  final double? currentWeightKg;
  final UnitSystem unitSystem;
  final bool isCompleted;
  final String? gender;
  final int dailyCalorieGoal;
  final int dailyProteinGoal;
  final int dailyCarbsGoal;
  final int dailyFatGoal;

  const OnboardingState({
    this.currentStep = 0,
    this.birthDate,
    this.goalWeight,
    this.heightFeet,
    this.heightInches,
    this.heightCm,
    this.currentWeight,
    this.currentWeightKg,
    this.unitSystem = UnitSystem.imperial,
    this.isCompleted = false,
    this.gender,
    this.dailyCalorieGoal = 2000,
    this.dailyProteinGoal = 100,
    this.dailyCarbsGoal = 200,
    this.dailyFatGoal = 65,
  });

  OnboardingState copyWith({
    int? currentStep,
    DateTime? birthDate,
    double? goalWeight,
    int? heightFeet,
    int? heightInches,
    double? heightCm,
    double? currentWeight,
    double? currentWeightKg,
    UnitSystem? unitSystem,
    bool? isCompleted,
    String? gender,
    int? dailyCalorieGoal,
    int? dailyProteinGoal,
    int? dailyCarbsGoal,
    int? dailyFatGoal,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      birthDate: birthDate ?? this.birthDate,
      goalWeight: goalWeight ?? this.goalWeight,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      heightCm: heightCm ?? this.heightCm,
      currentWeight: currentWeight ?? this.currentWeight,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      unitSystem: unitSystem ?? this.unitSystem,
      isCompleted: isCompleted ?? this.isCompleted,
      gender: gender ?? this.gender,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyProteinGoal: dailyProteinGoal ?? this.dailyProteinGoal,
      dailyCarbsGoal: dailyCarbsGoal ?? this.dailyCarbsGoal,
      dailyFatGoal: dailyFatGoal ?? this.dailyFatGoal,
    );
  }

  // Convert lbs to kg
  double? get goalWeightKg => goalWeight != null ? goalWeight! * 0.453592 : null;

  // Convert kg to lbs
  double? get currentWeightLbs =>
      currentWeightKg != null ? currentWeightKg! / 0.453592 : currentWeight;

  // Get height in cm
  double? get totalHeightCm {
    if (heightCm != null) return heightCm;
    if (heightFeet != null && heightInches != null) {
      return (heightFeet! * 12 + heightInches!) * 2.54;
    }
    return null;
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState()) {
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool('onboarding_completed') ?? false;
    state = state.copyWith(isCompleted: isCompleted);
  }

  void setBirthDate(DateTime date) {
    state = state.copyWith(birthDate: date);
  }

  void setGoalWeight(double weight) {
    state = state.copyWith(goalWeight: weight);
  }

  void setHeight({int? feet, int? inches, double? cm}) {
    state = state.copyWith(
      heightFeet: feet,
      heightInches: inches,
      heightCm: cm,
    );
  }

  void setCurrentWeight({double? lbs, double? kg}) {
    state = state.copyWith(
      currentWeight: lbs,
      currentWeightKg: kg,
    );
  }

  void setUnitSystem(UnitSystem system) {
    state = state.copyWith(unitSystem: system);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setDailyGoals({
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
  }) {
    state = state.copyWith(
      dailyCalorieGoal: calories,
      dailyProteinGoal: protein,
      dailyCarbsGoal: carbs,
      dailyFatGoal: fat,
    );
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    state = state.copyWith(isCompleted: true);
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', false);
    state = const OnboardingState();
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

final isOnboardingCompletedProvider = Provider<bool>((ref) {
  return ref.watch(onboardingProvider).isCompleted;
});
