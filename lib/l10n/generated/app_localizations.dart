import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Diet AI'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Become a better you'**
  String get signInToContinue;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address you used to sign up and we\'ll send you a password reset link.'**
  String get resetPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent to your email.'**
  String get resetLinkSent;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your journey to better health'**
  String get startYourJourney;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @createAPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createAPassword;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reenterPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our Terms of Service and Privacy Policy'**
  String get termsOfService;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailed(String error);

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed: {error}'**
  String signupFailed(String error);

  /// No description provided for @trackCaloriesWithAI.
  ///
  /// In en, this message translates to:
  /// **'Track calories with AI'**
  String get trackCaloriesWithAI;

  /// No description provided for @trackCaloriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Simply take a photo of your food and our AI will instantly analyze the nutritional content'**
  String get trackCaloriesDescription;

  /// No description provided for @setYourDailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Set your daily goals'**
  String get setYourDailyGoals;

  /// No description provided for @adjustAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can adjust these anytime in settings'**
  String get adjustAnytime;

  /// No description provided for @trackYourWeight.
  ///
  /// In en, this message translates to:
  /// **'Track your weight'**
  String get trackYourWeight;

  /// No description provided for @optionalWeightGoals.
  ///
  /// In en, this message translates to:
  /// **'Optional: Set your weight goals'**
  String get optionalWeightGoals;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fats;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @fiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fiber;

  /// No description provided for @sugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sugar;

  /// No description provided for @sodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodium;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @goalWeight.
  ///
  /// In en, this message translates to:
  /// **'Goal Weight'**
  String get goalWeight;

  /// No description provided for @changeGoal.
  ///
  /// In en, this message translates to:
  /// **'Change Goal'**
  String get changeGoal;

  /// No description provided for @enterYourWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your weight'**
  String get enterYourWeight;

  /// No description provided for @enterGoalWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your goal weight'**
  String get enterGoalWeight;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @dailyStepGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily step goal'**
  String get dailyStepGoal;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get steps;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @lbs.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbs;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @goalKg.
  ///
  /// In en, this message translates to:
  /// **'Goal {weight} kg'**
  String goalKg(int weight);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @caloriesEaten.
  ///
  /// In en, this message translates to:
  /// **'Calories eaten'**
  String get caloriesEaten;

  /// No description provided for @proteinEaten.
  ///
  /// In en, this message translates to:
  /// **'Protein eaten'**
  String get proteinEaten;

  /// No description provided for @carbsEaten.
  ///
  /// In en, this message translates to:
  /// **'Carbs eaten'**
  String get carbsEaten;

  /// No description provided for @fatEaten.
  ///
  /// In en, this message translates to:
  /// **'Fat eaten'**
  String get fatEaten;

  /// No description provided for @recentlyUploaded.
  ///
  /// In en, this message translates to:
  /// **'Recently uploaded'**
  String get recentlyUploaded;

  /// No description provided for @noMealsLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No meals logged yet'**
  String get noMealsLoggedYet;

  /// No description provided for @tapToAddFirstMeal.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first meal'**
  String get tapToAddFirstMeal;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoadingData(String error);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @groupsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Groups coming soon!'**
  String get groupsComingSoon;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @yourWeight.
  ///
  /// In en, this message translates to:
  /// **'Your Weight'**
  String get yourWeight;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal {weight} lbs'**
  String goal(int weight);

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Log Weight'**
  String get logWeight;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @weightProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight Progress'**
  String get weightProgress;

  /// No description provided for @percentOfGoal.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of goal'**
  String percentOfGoal(int percent);

  /// No description provided for @errorLoadingDataSimple.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingDataSimple;

  /// No description provided for @greatJobConsistency.
  ///
  /// In en, this message translates to:
  /// **'Great job! Consistency is key, and you\'re mastering it!'**
  String get greatJobConsistency;

  /// No description provided for @dailyAverageCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Average Calories'**
  String get dailyAverageCalories;

  /// No description provided for @cal.
  ///
  /// In en, this message translates to:
  /// **'cal'**
  String get cal;

  /// No description provided for @noWeightData.
  ///
  /// In en, this message translates to:
  /// **'No weight data'**
  String get noWeightData;

  /// No description provided for @weightLbs.
  ///
  /// In en, this message translates to:
  /// **'Weight (lbs)'**
  String get weightLbs;

  /// No description provided for @weightLogged.
  ///
  /// In en, this message translates to:
  /// **'Weight logged!'**
  String get weightLogged;

  /// No description provided for @goalWeightUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal weight updated!'**
  String get goalWeightUpdated;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @enterYourHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your height'**
  String get enterYourHeight;

  /// No description provided for @heightUpdated.
  ///
  /// In en, this message translates to:
  /// **'Height updated!'**
  String get heightUpdated;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @weeklyEnergy.
  ///
  /// In en, this message translates to:
  /// **'Weekly Energy'**
  String get weeklyEnergy;

  /// No description provided for @burned.
  ///
  /// In en, this message translates to:
  /// **'Burned'**
  String get burned;

  /// No description provided for @consumed.
  ///
  /// In en, this message translates to:
  /// **'Consumed'**
  String get consumed;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @yourBMI.
  ///
  /// In en, this message translates to:
  /// **'Your BMI'**
  String get yourBMI;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get bmiNormal;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiObese;

  /// No description provided for @heightNotSet.
  ///
  /// In en, this message translates to:
  /// **'Set your height in profile'**
  String get heightNotSet;

  /// No description provided for @range90d.
  ///
  /// In en, this message translates to:
  /// **'90D'**
  String get range90d;

  /// No description provided for @range6m.
  ///
  /// In en, this message translates to:
  /// **'6M'**
  String get range6m;

  /// No description provided for @range1y.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get range1y;

  /// No description provided for @rangeAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get rangeAll;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @dailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get dailyGoals;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @goalsAndTracking.
  ///
  /// In en, this message translates to:
  /// **'Goals & Tracking'**
  String get goalsAndTracking;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @weightHistory.
  ///
  /// In en, this message translates to:
  /// **'Weight History'**
  String get weightHistory;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmMessage;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteEntry;

  /// No description provided for @deleteEntryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this food entry?'**
  String get deleteEntryConfirm;

  /// No description provided for @sharedFromDieterAI.
  ///
  /// In en, this message translates to:
  /// **'Shared from Diet AI 🍎'**
  String get sharedFromDieterAI;

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get entryDeleted;

  /// No description provided for @savePhotoToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save photo to gallery'**
  String get savePhotoToGallery;

  /// No description provided for @photoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved to gallery'**
  String get photoSaved;

  /// No description provided for @failedToSavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to save photo'**
  String get failedToSavePhoto;

  /// No description provided for @cameraNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Camera not available'**
  String get cameraNotAvailable;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera error: {error}'**
  String cameraError(String error);

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get pickFromGallery;

  /// No description provided for @scanFood.
  ///
  /// In en, this message translates to:
  /// **'Scan Food'**
  String get scanFood;

  /// No description provided for @foodDatabase.
  ///
  /// In en, this message translates to:
  /// **'Food Database'**
  String get foodDatabase;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @foodLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Label'**
  String get foodLabel;

  /// No description provided for @zoomHalf.
  ///
  /// In en, this message translates to:
  /// **'.5x'**
  String get zoomHalf;

  /// No description provided for @zoomOne.
  ///
  /// In en, this message translates to:
  /// **'1x'**
  String get zoomOne;

  /// No description provided for @analyzingFood.
  ///
  /// In en, this message translates to:
  /// **'Analyzing food...'**
  String get analyzingFood;

  /// No description provided for @failedToCaptureImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture image'**
  String get failedToCaptureImage;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed: {error}'**
  String analysisFailed(String error);

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get howToUse;

  /// No description provided for @howToUseStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Point your camera at the food'**
  String get howToUseStep1;

  /// No description provided for @howToUseStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Make sure the food is clearly visible'**
  String get howToUseStep2;

  /// No description provided for @howToUseStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Tap the camera button to analyze'**
  String get howToUseStep3;

  /// No description provided for @howToUseStep4.
  ///
  /// In en, this message translates to:
  /// **'4. Review and adjust the results if needed'**
  String get howToUseStep4;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @unknownFood.
  ///
  /// In en, this message translates to:
  /// **'Unknown Food'**
  String get unknownFood;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get addMore;

  /// No description provided for @noIngredientsDetected.
  ///
  /// In en, this message translates to:
  /// **'No ingredients detected'**
  String get noIngredientsDetected;

  /// No description provided for @fixResults.
  ///
  /// In en, this message translates to:
  /// **'Fix Results'**
  String get fixResults;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient'**
  String get addIngredient;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @amountOptional.
  ///
  /// In en, this message translates to:
  /// **'Amount (optional)'**
  String get amountOptional;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @foodName.
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get foodName;

  /// No description provided for @proteinG.
  ///
  /// In en, this message translates to:
  /// **'Protein (g)'**
  String get proteinG;

  /// No description provided for @carbsG.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get carbsG;

  /// No description provided for @fatG.
  ///
  /// In en, this message translates to:
  /// **'Fat (g)'**
  String get fatG;

  /// No description provided for @foodEntrySaved.
  ///
  /// In en, this message translates to:
  /// **'Food entry saved!'**
  String get foodEntrySaved;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String failedToSave(String error);

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get defaultUserName;

  /// No description provided for @defaultUserEmail.
  ///
  /// In en, this message translates to:
  /// **'john.doe@example.com'**
  String get defaultUserEmail;

  /// No description provided for @mealReminders.
  ///
  /// In en, this message translates to:
  /// **'Meal Reminders'**
  String get mealReminders;

  /// No description provided for @mealRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get reminded to log your meals'**
  String get mealRemindersDescription;

  /// No description provided for @weightReminders.
  ///
  /// In en, this message translates to:
  /// **'Weight Reminders'**
  String get weightReminders;

  /// No description provided for @weightRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get reminded to log your weight'**
  String get weightRemindersDescription;

  /// No description provided for @weeklyReports.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reports'**
  String get weeklyReports;

  /// No description provided for @weeklyReportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive weekly progress summaries'**
  String get weeklyReportsDescription;

  /// No description provided for @savedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites'**
  String get savedToFavorites;

  /// No description provided for @removedFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved foods'**
  String get removedFromSaved;

  /// No description provided for @savedFoods.
  ///
  /// In en, this message translates to:
  /// **'Saved Foods'**
  String get savedFoods;

  /// No description provided for @noSavedFoods.
  ///
  /// In en, this message translates to:
  /// **'No saved foods yet'**
  String get noSavedFoods;

  /// No description provided for @logThisFood.
  ///
  /// In en, this message translates to:
  /// **'Log this food'**
  String get logThisFood;

  /// No description provided for @party.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get party;

  /// No description provided for @partyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon! 🎉'**
  String get partyComingSoon;

  /// No description provided for @partyDescription.
  ///
  /// In en, this message translates to:
  /// **'Achieve diet goals with friends and support each other to build healthy habits.'**
  String get partyDescription;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @logExercise.
  ///
  /// In en, this message translates to:
  /// **'Log Exercise'**
  String get logExercise;

  /// No description provided for @run.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get run;

  /// No description provided for @runDescription.
  ///
  /// In en, this message translates to:
  /// **'Running, jogging, sprinting, etc.'**
  String get runDescription;

  /// No description provided for @weightLifting.
  ///
  /// In en, this message translates to:
  /// **'Weight lifting'**
  String get weightLifting;

  /// No description provided for @weightLiftingDescription.
  ///
  /// In en, this message translates to:
  /// **'Machines, free weights, etc.'**
  String get weightLiftingDescription;

  /// No description provided for @describe.
  ///
  /// In en, this message translates to:
  /// **'Describe'**
  String get describe;

  /// No description provided for @describeDescription.
  ///
  /// In en, this message translates to:
  /// **'Write your workout in text'**
  String get describeDescription;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @manualDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter exactly how many calories you burned'**
  String get manualDescription;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensity;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// No description provided for @enterDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter duration'**
  String get enterDuration;

  /// No description provided for @runLogged.
  ///
  /// In en, this message translates to:
  /// **'Run logged: {duration} min ({intensity} intensity)'**
  String runLogged(int duration, String intensity);

  /// No description provided for @exerciseLogged.
  ///
  /// In en, this message translates to:
  /// **'{type} logged: {duration} minutes'**
  String exerciseLogged(String type, int duration);

  /// No description provided for @describeYourWorkout.
  ///
  /// In en, this message translates to:
  /// **'Describe your workout'**
  String get describeYourWorkout;

  /// No description provided for @describeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"30 minutes of yoga and 20 push-ups\"'**
  String get describeHint;

  /// No description provided for @exerciseLoggedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exercise logged!'**
  String get exerciseLoggedSuccess;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories burned'**
  String get caloriesBurned;

  /// No description provided for @enterCaloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Enter calories burned'**
  String get enterCaloriesBurned;

  /// No description provided for @caloriesBurnedLogged.
  ///
  /// In en, this message translates to:
  /// **'{calories} calories burned logged!'**
  String caloriesBurnedLogged(int calories);

  /// No description provided for @lightWeights.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightWeights;

  /// No description provided for @moderateWeights.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateWeights;

  /// No description provided for @heavyWeights.
  ///
  /// In en, this message translates to:
  /// **'Heavy'**
  String get heavyWeights;

  /// No description provided for @weightLiftingLogged.
  ///
  /// In en, this message translates to:
  /// **'Weight lifting logged: {duration} min ({intensity} intensity)'**
  String weightLiftingLogged(int duration, String intensity);

  /// No description provided for @analyzingExercise.
  ///
  /// In en, this message translates to:
  /// **'Analyzing exercise...'**
  String get analyzingExercise;

  /// No description provided for @analyzeExercise.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyzeExercise;

  /// No description provided for @exerciseAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to analyze exercise'**
  String get exerciseAnalysisFailed;

  /// No description provided for @logFood.
  ///
  /// In en, this message translates to:
  /// **'Log Food'**
  String get logFood;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @myFoods.
  ///
  /// In en, this message translates to:
  /// **'My foods'**
  String get myFoods;

  /// No description provided for @myMeals.
  ///
  /// In en, this message translates to:
  /// **'My meals'**
  String get myMeals;

  /// No description provided for @describeWhatYouAte.
  ///
  /// In en, this message translates to:
  /// **'Describe what you ate'**
  String get describeWhatYouAte;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// No description provided for @manualAdd.
  ///
  /// In en, this message translates to:
  /// **'Manual Add'**
  String get manualAdd;

  /// No description provided for @voiceLog.
  ///
  /// In en, this message translates to:
  /// **'Voice Log'**
  String get voiceLog;

  /// No description provided for @noCustomFoodsYet.
  ///
  /// In en, this message translates to:
  /// **'No custom foods yet'**
  String get noCustomFoodsYet;

  /// No description provided for @foodsYouCreateWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Foods you create will appear here.'**
  String get foodsYouCreateWillAppearHere;

  /// No description provided for @noSavedMealsYet.
  ///
  /// In en, this message translates to:
  /// **'No saved meals yet'**
  String get noSavedMealsYet;

  /// No description provided for @combineFoodsIntoMeals.
  ///
  /// In en, this message translates to:
  /// **'Combine foods into meals for quick logging.'**
  String get combineFoodsIntoMeals;

  /// No description provided for @tapToSaveHere.
  ///
  /// In en, this message translates to:
  /// **'Tap bookmark on any food to save here.'**
  String get tapToSaveHere;

  /// No description provided for @pleaseSignInToLogFood.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to log food'**
  String get pleaseSignInToLogFood;

  /// No description provided for @failedToLogFood.
  ///
  /// In en, this message translates to:
  /// **'Failed to log food: {error}'**
  String failedToLogFood(String error);

  /// No description provided for @addedFood.
  ///
  /// In en, this message translates to:
  /// **'Added {name}'**
  String addedFood(String name);

  /// No description provided for @voiceLoggingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Voice logging coming soon'**
  String get voiceLoggingComingSoon;

  /// No description provided for @addFoodManually.
  ///
  /// In en, this message translates to:
  /// **'Add Food Manually'**
  String get addFoodManually;

  /// No description provided for @addFood.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFood;

  /// No description provided for @weightChanges.
  ///
  /// In en, this message translates to:
  /// **'Weight Changes'**
  String get weightChanges;

  /// No description provided for @day3.
  ///
  /// In en, this message translates to:
  /// **'3 day'**
  String get day3;

  /// No description provided for @day7.
  ///
  /// In en, this message translates to:
  /// **'7 day'**
  String get day7;

  /// No description provided for @day14.
  ///
  /// In en, this message translates to:
  /// **'14 day'**
  String get day14;

  /// No description provided for @day30.
  ///
  /// In en, this message translates to:
  /// **'30 day'**
  String get day30;

  /// No description provided for @day90.
  ///
  /// In en, this message translates to:
  /// **'90 day'**
  String get day90;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @noChange.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get noChange;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;

  /// No description provided for @barcodeScanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get barcodeScanner;

  /// No description provided for @barcodeScannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at a barcode on any food package to instantly get nutrition information.'**
  String get barcodeScannerDescription;

  /// No description provided for @barcodeTip1.
  ///
  /// In en, this message translates to:
  /// **'Make sure the barcode is well-lit'**
  String get barcodeTip1;

  /// No description provided for @barcodeTip2.
  ///
  /// In en, this message translates to:
  /// **'Center the barcode in the frame'**
  String get barcodeTip2;

  /// No description provided for @barcodeTip3.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone steady'**
  String get barcodeTip3;

  /// No description provided for @nutritionLabelScanner.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Label Scanner'**
  String get nutritionLabelScanner;

  /// No description provided for @nutritionLabelDescription.
  ///
  /// In en, this message translates to:
  /// **'Get nutrition details from any label to track your intake accurately.'**
  String get nutritionLabelDescription;

  /// No description provided for @quote1.
  ///
  /// In en, this message translates to:
  /// **'Start your day healthy! 💪'**
  String get quote1;

  /// No description provided for @quote2.
  ///
  /// In en, this message translates to:
  /// **'Small changes make big results.'**
  String get quote2;

  /// No description provided for @quote3.
  ///
  /// In en, this message translates to:
  /// **'Consistency is the best weapon.'**
  String get quote3;

  /// No description provided for @quote4.
  ///
  /// In en, this message translates to:
  /// **'A healthy diet creates a happy life.'**
  String get quote4;

  /// No description provided for @quote5.
  ///
  /// In en, this message translates to:
  /// **'Today\'s effort makes tomorrow\'s you.'**
  String get quote5;

  /// No description provided for @quote6.
  ///
  /// In en, this message translates to:
  /// **'Don\'t give up, you can do it!'**
  String get quote6;

  /// No description provided for @quote7.
  ///
  /// In en, this message translates to:
  /// **'One step at a time, towards your goal.'**
  String get quote7;

  /// No description provided for @quote8.
  ///
  /// In en, this message translates to:
  /// **'Health is the most precious asset.'**
  String get quote8;

  /// No description provided for @quote9.
  ///
  /// In en, this message translates to:
  /// **'Great choice today! ✨'**
  String get quote9;

  /// No description provided for @quote10.
  ///
  /// In en, this message translates to:
  /// **'Your efforts won\'t betray you.'**
  String get quote10;

  /// No description provided for @quote11.
  ///
  /// In en, this message translates to:
  /// **'A little better every day.'**
  String get quote11;

  /// No description provided for @quote12.
  ///
  /// In en, this message translates to:
  /// **'A healthy body nurtures a healthy mind.'**
  String get quote12;

  /// No description provided for @quote13.
  ///
  /// In en, this message translates to:
  /// **'Three days? Start again from today!'**
  String get quote13;

  /// No description provided for @quote14.
  ///
  /// In en, this message translates to:
  /// **'Believe in yourself, you\'re amazing.'**
  String get quote14;

  /// No description provided for @quote15.
  ///
  /// In en, this message translates to:
  /// **'Good habits make a good life.'**
  String get quote15;

  /// No description provided for @roleModel.
  ///
  /// In en, this message translates to:
  /// **'Role Model'**
  String get roleModel;

  /// No description provided for @addRoleModel.
  ///
  /// In en, this message translates to:
  /// **'Add your motivation photo'**
  String get addRoleModel;

  /// No description provided for @roleModelMotivation.
  ///
  /// In en, this message translates to:
  /// **'This is your goal!'**
  String get roleModelMotivation;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacyIntroTitle;

  /// No description provided for @privacyIntroContent.
  ///
  /// In en, this message translates to:
  /// **'Diet AI (\"we\", \"our\", or \"us\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.'**
  String get privacyIntroContent;

  /// No description provided for @privacyDataCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacyDataCollectionTitle;

  /// No description provided for @privacyDataCollectionContent.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly, including:\n\n• Account information (email, name)\n• Health data (weight, food logs, exercise records)\n• Photos of food for AI analysis\n• Device information and usage data\n\nWe do not sell your personal information to third parties.'**
  String get privacyDataCollectionContent;

  /// No description provided for @privacyDataUseTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacyDataUseTitle;

  /// No description provided for @privacyDataUseContent.
  ///
  /// In en, this message translates to:
  /// **'We use your information to:\n\n• Provide and improve our services\n• Analyze food photos using AI technology\n• Track your nutrition and fitness progress\n• Send you reminders and notifications (if enabled)\n• Communicate with you about our services'**
  String get privacyDataUseContent;

  /// No description provided for @privacyDataProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get privacyDataProtectionTitle;

  /// No description provided for @privacyDataProtectionContent.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate security measures to protect your personal information. Your data is encrypted during transmission and stored securely. However, no method of transmission over the Internet is 100% secure.'**
  String get privacyDataProtectionContent;

  /// No description provided for @privacyUserRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacyUserRightsTitle;

  /// No description provided for @privacyUserRightsContent.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:\n\n• Access your personal data\n• Request correction of your data\n• Request deletion of your account and data\n• Opt-out of marketing communications\n\nTo exercise these rights, please contact us.'**
  String get privacyUserRightsContent;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactContent.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at:\n\nkernys01@gmail.com'**
  String get privacyContactContent;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: January 2025'**
  String get privacyLastUpdated;

  /// No description provided for @customerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupport;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @deleteWeightLog.
  ///
  /// In en, this message translates to:
  /// **'Delete Weight Log'**
  String get deleteWeightLog;

  /// No description provided for @deleteWeightLogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this weight log?'**
  String get deleteWeightLogConfirm;

  /// No description provided for @weightLogDeleted.
  ///
  /// In en, this message translates to:
  /// **'Weight log deleted'**
  String get weightLogDeleted;

  /// No description provided for @errorDeletingWeightLog.
  ///
  /// In en, this message translates to:
  /// **'Error deleting weight log'**
  String get errorDeletingWeightLog;

  /// No description provided for @tapToName.
  ///
  /// In en, this message translates to:
  /// **'Tap to Name'**
  String get tapToName;

  /// No description provided for @ingredientsHidden.
  ///
  /// In en, this message translates to:
  /// **'Ingredients hidden'**
  String get ingredientsHidden;

  /// No description provided for @learnWhy.
  ///
  /// In en, this message translates to:
  /// **'Learn why'**
  String get learnWhy;

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get log;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @pleaseEnterFoodName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a food name'**
  String get pleaseEnterFoodName;

  /// No description provided for @foodLogged.
  ///
  /// In en, this message translates to:
  /// **'Food logged'**
  String get foodLogged;

  /// No description provided for @errorLoggingFood.
  ///
  /// In en, this message translates to:
  /// **'Error logging food'**
  String get errorLoggingFood;

  /// No description provided for @voiceRecording.
  ///
  /// In en, this message translates to:
  /// **'Voice Recording'**
  String get voiceRecording;

  /// No description provided for @tapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap to record'**
  String get tapToRecord;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now, describe what you ate'**
  String get speakNow;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noSearchResults;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
