import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1A1A1A);
  static const Color secondary = Color(0xFFF5F5F5);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F8F8);
  static const Color card = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B35);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);

  // Macro Colors
  static const Color protein = Color(0xFFE57373);
  static const Color carbs = Color(0xFFFFB74D);
  static const Color fat = Color(0xFF64B5F6);
  static const Color calories = Color(0xFF1A1A1A);

  // Progress Colors
  static const Color progressBackground = Color(0xFFE0E0E0);
  static const Color streak = Color(0xFFFF6B35);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFF0F0F0);

  // Shadow
  static const Color shadow = Color(0x1A000000);

  // Dark mode colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);
  static const Color borderDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF2C2C2C);
}

// Theme-aware color extension
extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor => isDark ? AppColors.backgroundDark : AppColors.background;
  Color get surfaceColor => isDark ? AppColors.surfaceDark : AppColors.surface;
  Color get cardColor => isDark ? AppColors.cardDark : AppColors.card;
  Color get textPrimaryColor => isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get textSecondaryColor => isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  Color get textTertiaryColor => isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
  Color get borderColor => isDark ? AppColors.borderDark : AppColors.border;
  Color get dividerColor => isDark ? AppColors.dividerDark : AppColors.divider;
}
