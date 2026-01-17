class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Diet AI';
  static const String appVersion = '1.0.0';

  // Default Goals
  static const int defaultCalorieGoal = 2500;
  static const int defaultProteinGoal = 150;
  static const int defaultCarbsGoal = 275;
  static const int defaultFatGoal = 70;

  // API Configuration
  static const String apiBaseUrl = 'https://dieter-api.vercel.app/api';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String userGoalsKey = 'user_goals';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
