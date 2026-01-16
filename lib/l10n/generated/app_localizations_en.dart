// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Diet AI';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInToContinue => 'Sign in to continue tracking your nutrition';

  @override
  String get createAccount => 'Create Account';

  @override
  String get startYourJourney => 'Start your journey to better health';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get createAPassword => 'Create a password';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reenterPassword => 'Re-enter your password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get or => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get termsOfService =>
      'By signing up, you agree to our Terms of Service and Privacy Policy';

  @override
  String loginFailed(String error) {
    return 'Login failed: $error';
  }

  @override
  String signupFailed(String error) {
    return 'Sign up failed: $error';
  }

  @override
  String get trackCaloriesWithAI => 'Track calories with AI';

  @override
  String get trackCaloriesDescription =>
      'Simply take a photo of your food and our AI will instantly analyze the nutritional content';

  @override
  String get setYourDailyGoals => 'Set your daily goals';

  @override
  String get adjustAnytime => 'You can adjust these anytime in settings';

  @override
  String get trackYourWeight => 'Track your weight';

  @override
  String get optionalWeightGoals => 'Optional: Set your weight goals';

  @override
  String get dailyCalories => 'Daily Calories';

  @override
  String get protein => 'Protein';

  @override
  String get carbohydrates => 'Carbohydrates';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get fats => 'Fats';

  @override
  String get calories => 'Calories';

  @override
  String get currentWeight => 'Current Weight';

  @override
  String get goalWeight => 'Goal Weight';

  @override
  String get enterYourWeight => 'Enter your weight';

  @override
  String get enterGoalWeight => 'Enter your goal weight';

  @override
  String get lbs => 'lbs';

  @override
  String get back => 'Back';

  @override
  String get continue_ => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String get caloriesEaten => 'Calories eaten';

  @override
  String get proteinEaten => 'Protein eaten';

  @override
  String get carbsEaten => 'Carbs eaten';

  @override
  String get fatEaten => 'Fat eaten';

  @override
  String get recentlyUploaded => 'Recently uploaded';

  @override
  String get noMealsLoggedYet => 'No meals logged yet';

  @override
  String get tapToAddFirstMeal => 'Tap + to add your first meal';

  @override
  String errorLoadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get home => 'Home';

  @override
  String get progress => 'Progress';

  @override
  String get groups => 'Groups';

  @override
  String get groupsComingSoon => 'Groups coming soon!';

  @override
  String get profile => 'Profile';

  @override
  String get yourWeight => 'Your Weight';

  @override
  String goal(int weight) {
    return 'Goal $weight lbs';
  }

  @override
  String get logWeight => 'Log Weight';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get weightProgress => 'Weight Progress';

  @override
  String percentOfGoal(int percent) {
    return '$percent% of goal';
  }

  @override
  String get errorLoadingDataSimple => 'Error loading data';

  @override
  String get greatJobConsistency =>
      'Great job! Consistency is key, and you\'re mastering it!';

  @override
  String get dailyAverageCalories => 'Daily Average Calories';

  @override
  String get cal => 'cal';

  @override
  String get noWeightData => 'No weight data';

  @override
  String get weightLbs => 'Weight (lbs)';

  @override
  String get weightLogged => 'Weight logged!';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get range90d => '90D';

  @override
  String get range6m => '6M';

  @override
  String get range1y => '1Y';

  @override
  String get rangeAll => 'ALL';

  @override
  String get edit => 'Edit';

  @override
  String get dailyGoals => 'Daily Goals';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get korean => 'Korean';

  @override
  String get units => 'Units';

  @override
  String get imperial => 'Imperial';

  @override
  String get metric => 'Metric';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get off => 'Off';

  @override
  String get on => 'On';

  @override
  String get privacy => 'Privacy';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get app => 'App';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get about => 'About';

  @override
  String get signOutConfirmTitle => 'Sign Out';

  @override
  String get signOutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get share => 'Share';

  @override
  String get delete => 'Delete';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String get deleteEntryConfirm =>
      'Are you sure you want to delete this food entry?';

  @override
  String get sharedFromDieterAI => 'Shared from Diet AI 🍎';

  @override
  String get entryDeleted => 'Entry deleted';

  @override
  String get cameraNotAvailable => 'Camera not available';

  @override
  String cameraError(String error) {
    return 'Camera error: $error';
  }

  @override
  String get pickFromGallery => 'Pick from Gallery';

  @override
  String get scanFood => 'Scan Food';

  @override
  String get barcode => 'Barcode';

  @override
  String get foodLabel => 'Food Label';

  @override
  String get zoomHalf => '.5x';

  @override
  String get zoomOne => '1x';

  @override
  String get analyzingFood => 'Analyzing food...';

  @override
  String get failedToCaptureImage => 'Failed to capture image';

  @override
  String analysisFailed(String error) {
    return 'Analysis failed: $error';
  }

  @override
  String get howToUse => 'How to use';

  @override
  String get howToUseStep1 => '1. Point your camera at the food';

  @override
  String get howToUseStep2 => '2. Make sure the food is clearly visible';

  @override
  String get howToUseStep3 => '3. Tap the camera button to analyze';

  @override
  String get howToUseStep4 => '4. Review and adjust the results if needed';

  @override
  String get gotIt => 'Got it';

  @override
  String get nutrition => 'Nutrition';

  @override
  String get unknownFood => 'Unknown Food';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get addMore => 'Add more';

  @override
  String get noIngredientsDetected => 'No ingredients detected';

  @override
  String get fixResults => 'Fix Results';

  @override
  String get done => 'Done';

  @override
  String get addIngredient => 'Add Ingredient';

  @override
  String get name => 'Name';

  @override
  String get amountOptional => 'Amount (optional)';

  @override
  String get add => 'Add';

  @override
  String get foodName => 'Food Name';

  @override
  String get proteinG => 'Protein (g)';

  @override
  String get carbsG => 'Carbs (g)';

  @override
  String get fatG => 'Fat (g)';

  @override
  String get foodEntrySaved => 'Food entry saved!';

  @override
  String failedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get defaultUserName => 'John Doe';

  @override
  String get defaultUserEmail => 'john.doe@example.com';
}
