import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Unit system enum
enum UnitSystem { imperial, metric }

// App settings state
class AppSettings {
  final UnitSystem unitSystem;
  final bool darkMode;
  final String locale;
  final bool mealReminders;
  final bool weightReminders;
  final bool weeklyReports;

  const AppSettings({
    this.unitSystem = UnitSystem.imperial,
    this.darkMode = false,
    this.locale = 'en',
    this.mealReminders = true,
    this.weightReminders = true,
    this.weeklyReports = true,
  });

  AppSettings copyWith({
    UnitSystem? unitSystem,
    bool? darkMode,
    String? locale,
    bool? mealReminders,
    bool? weightReminders,
    bool? weeklyReports,
  }) {
    return AppSettings(
      unitSystem: unitSystem ?? this.unitSystem,
      darkMode: darkMode ?? this.darkMode,
      locale: locale ?? this.locale,
      mealReminders: mealReminders ?? this.mealReminders,
      weightReminders: weightReminders ?? this.weightReminders,
      weeklyReports: weeklyReports ?? this.weeklyReports,
    );
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final unitSystemStr = prefs.getString('unit_system') ?? 'imperial';
    final darkMode = prefs.getBool('dark_mode') ?? false;
    final locale = prefs.getString('locale') ?? 'en';
    final mealReminders = prefs.getBool('meal_reminders') ?? true;
    final weightReminders = prefs.getBool('weight_reminders') ?? true;
    final weeklyReports = prefs.getBool('weekly_reports') ?? true;

    state = AppSettings(
      unitSystem: unitSystemStr == 'metric' ? UnitSystem.metric : UnitSystem.imperial,
      darkMode: darkMode,
      locale: locale,
      mealReminders: mealReminders,
      weightReminders: weightReminders,
      weeklyReports: weeklyReports,
    );
  }

  Future<void> setUnitSystem(UnitSystem unitSystem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit_system', unitSystem == UnitSystem.metric ? 'metric' : 'imperial');
    state = state.copyWith(unitSystem: unitSystem);
  }

  Future<void> setDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', darkMode);
    state = state.copyWith(darkMode: darkMode);
  }

  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
    state = state.copyWith(locale: locale);
  }

  Future<void> setMealReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('meal_reminders', enabled);
    state = state.copyWith(mealReminders: enabled);
  }

  Future<void> setWeightReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('weight_reminders', enabled);
    state = state.copyWith(weightReminders: enabled);
  }

  Future<void> setWeeklyReports(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('weekly_reports', enabled);
    state = state.copyWith(weeklyReports: enabled);
  }

  // Convert weight based on unit system
  double convertWeight(double weightInLbs, {bool toDisplay = true}) {
    if (state.unitSystem == UnitSystem.metric) {
      // Convert lbs to kg
      return toDisplay ? weightInLbs * 0.453592 : weightInLbs / 0.453592;
    }
    return weightInLbs;
  }

  // Get weight unit label
  String get weightUnit => state.unitSystem == UnitSystem.metric ? 'kg' : 'lbs';
}

// Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

// Convenience providers
final unitSystemProvider = Provider<UnitSystem>((ref) {
  return ref.watch(settingsProvider).unitSystem;
});

final darkModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).darkMode;
});

final localeProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).locale;
});
