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
  String get kg => 'kg';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String goalKg(int weight) {
    return 'Goal $weight kg';
  }

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

  @override
  String get mealReminders => 'Meal Reminders';

  @override
  String get mealRemindersDescription => 'Get reminded to log your meals';

  @override
  String get weightReminders => 'Weight Reminders';

  @override
  String get weightRemindersDescription => 'Get reminded to log your weight';

  @override
  String get weeklyReports => 'Weekly Reports';

  @override
  String get weeklyReportsDescription => 'Receive weekly progress summaries';

  @override
  String get savedToFavorites => 'Saved to favorites';

  @override
  String get removedFromSaved => 'Removed from saved foods';

  @override
  String get savedFoods => 'Saved Foods';

  @override
  String get noSavedFoods => 'No saved foods yet';

  @override
  String get logThisFood => 'Log this food';

  @override
  String get party => 'Party';

  @override
  String get partyComingSoon => 'Coming Soon! 🎉';

  @override
  String get partyDescription =>
      'Achieve diet goals with friends and support each other to build healthy habits.';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get exercise => 'Exercise';

  @override
  String get logExercise => 'Log Exercise';

  @override
  String get run => 'Run';

  @override
  String get runDescription => 'Running, jogging, sprinting, etc.';

  @override
  String get weightLifting => 'Weight lifting';

  @override
  String get weightLiftingDescription => 'Machines, free weights, etc.';

  @override
  String get describe => 'Describe';

  @override
  String get describeDescription => 'Write your workout in text';

  @override
  String get manual => 'Manual';

  @override
  String get manualDescription => 'Enter exactly how many calories you burned';

  @override
  String get intensity => 'Intensity';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get durationMinutes => 'Duration (minutes)';

  @override
  String get enterDuration => 'Enter duration';

  @override
  String runLogged(int duration, String intensity) {
    return 'Run logged: $duration min ($intensity intensity)';
  }

  @override
  String exerciseLogged(String type, int duration) {
    return '$type logged: $duration minutes';
  }

  @override
  String get describeYourWorkout => 'Describe your workout';

  @override
  String get describeHint => 'e.g., \"30 minutes of yoga and 20 push-ups\"';

  @override
  String get exerciseLoggedSuccess => 'Exercise logged!';

  @override
  String get caloriesBurned => 'Calories burned';

  @override
  String get enterCaloriesBurned => 'Enter calories burned';

  @override
  String caloriesBurnedLogged(int calories) {
    return '$calories calories burned logged!';
  }

  @override
  String get logFood => 'Log Food';

  @override
  String get all => 'All';

  @override
  String get myFoods => 'My foods';

  @override
  String get myMeals => 'My meals';

  @override
  String get describeWhatYouAte => 'Describe what you ate';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get manualAdd => 'Manual Add';

  @override
  String get voiceLog => 'Voice Log';

  @override
  String get noCustomFoodsYet => 'No custom foods yet';

  @override
  String get foodsYouCreateWillAppearHere =>
      'Foods you create will appear here.';

  @override
  String get noSavedMealsYet => 'No saved meals yet';

  @override
  String get combineFoodsIntoMeals =>
      'Combine foods into meals for quick logging.';

  @override
  String get tapToSaveHere => 'Tap bookmark on any food to save here.';

  @override
  String get pleaseSignInToLogFood => 'Please sign in to log food';

  @override
  String failedToLogFood(String error) {
    return 'Failed to log food: $error';
  }

  @override
  String addedFood(String name) {
    return 'Added $name';
  }

  @override
  String get voiceLoggingComingSoon => 'Voice logging coming soon';

  @override
  String get addFoodManually => 'Add Food Manually';

  @override
  String get addFood => 'Add Food';

  @override
  String get weightChanges => 'Weight Changes';

  @override
  String get day3 => '3 day';

  @override
  String get day7 => '7 day';

  @override
  String get day14 => '14 day';

  @override
  String get day30 => '30 day';

  @override
  String get day90 => '90 day';

  @override
  String get allTime => 'All Time';

  @override
  String get noChange => 'No change';

  @override
  String get increase => 'Increase';

  @override
  String get decrease => 'Decrease';

  @override
  String get barcodeScanner => 'Barcode Scanner';

  @override
  String get barcodeScannerDescription =>
      'Point your camera at a barcode on any food package to instantly get nutrition information.';

  @override
  String get barcodeTip1 => 'Make sure the barcode is well-lit';

  @override
  String get barcodeTip2 => 'Center the barcode in the frame';

  @override
  String get barcodeTip3 => 'Hold your phone steady';

  @override
  String get nutritionLabelScanner => 'Nutrition Label Scanner';

  @override
  String get nutritionLabelDescription =>
      'Get nutrition details from any label to track your intake accurately.';

  @override
  String get quote1 => 'Start your day healthy! 💪';

  @override
  String get quote2 => 'Small changes make big results.';

  @override
  String get quote3 => 'Consistency is the best weapon.';

  @override
  String get quote4 => 'A healthy diet creates a happy life.';

  @override
  String get quote5 => 'Today\'s effort makes tomorrow\'s you.';

  @override
  String get quote6 => 'Don\'t give up, you can do it!';

  @override
  String get quote7 => 'One step at a time, towards your goal.';

  @override
  String get quote8 => 'Health is the most precious asset.';

  @override
  String get quote9 => 'Great choice today! ✨';

  @override
  String get quote10 => 'Your efforts won\'t betray you.';

  @override
  String get quote11 => 'A little better every day.';

  @override
  String get quote12 => 'A healthy body nurtures a healthy mind.';

  @override
  String get quote13 => 'Three days? Start again from today!';

  @override
  String get quote14 => 'Believe in yourself, you\'re amazing.';

  @override
  String get quote15 => 'Good habits make a good life.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyIntroTitle => 'Introduction';

  @override
  String get privacyIntroContent =>
      'Diet AI (\"we\", \"our\", or \"us\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.';

  @override
  String get privacyDataCollectionTitle => 'Information We Collect';

  @override
  String get privacyDataCollectionContent =>
      'We collect information you provide directly, including:\n\n• Account information (email, name)\n• Health data (weight, food logs, exercise records)\n• Photos of food for AI analysis\n• Device information and usage data\n\nWe do not sell your personal information to third parties.';

  @override
  String get privacyDataUseTitle => 'How We Use Your Information';

  @override
  String get privacyDataUseContent =>
      'We use your information to:\n\n• Provide and improve our services\n• Analyze food photos using AI technology\n• Track your nutrition and fitness progress\n• Send you reminders and notifications (if enabled)\n• Communicate with you about our services';

  @override
  String get privacyDataProtectionTitle => 'Data Security';

  @override
  String get privacyDataProtectionContent =>
      'We implement appropriate security measures to protect your personal information. Your data is encrypted during transmission and stored securely. However, no method of transmission over the Internet is 100% secure.';

  @override
  String get privacyUserRightsTitle => 'Your Rights';

  @override
  String get privacyUserRightsContent =>
      'You have the right to:\n\n• Access your personal data\n• Request correction of your data\n• Request deletion of your account and data\n• Opt-out of marketing communications\n\nTo exercise these rights, please contact us.';

  @override
  String get privacyContactTitle => 'Contact Us';

  @override
  String get privacyContactContent =>
      'If you have any questions about this Privacy Policy, please contact us at:\n\nkernys01@gmail.com';

  @override
  String get privacyLastUpdated => 'Last updated: January 2025';

  @override
  String get customerSupport => 'Customer Support';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get sendEmail => 'Send Email';
}
