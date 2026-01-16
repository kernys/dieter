class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Dieter AI';
  static const String appVersion = '1.0.0';

  // Default Goals
  static const int defaultCalorieGoal = 2500;
  static const int defaultProteinGoal = 150;
  static const int defaultCarbsGoal = 275;
  static const int defaultFatGoal = 70;

  // API Configuration
  static const String apiBaseUrl = 'https://dieter-api.vercel.app/api';

  // API Keys (Replace with your actual keys)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String userGoalsKey = 'user_goals';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
