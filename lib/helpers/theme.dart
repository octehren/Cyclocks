import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03A9F4);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  // Primary colors
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color primaryGreen = Color(0xFF388E3C);
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryOrange = Color(0xFFF57C00);
  static const Color primaryPurple = Color(0xFF7B1FA2);
  static const Color primaryPink = Color(0xFFC2185B);
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color primaryAmber = Color(0xFFFFA000);
  
  // Secondary colors
  static const Color secondaryRed = Color(0xFFFFCDD2);
  static const Color secondaryGreen = Color(0xFFC8E6C9);
  static const Color secondaryBlue = Color(0xFFBBDEFB);
  static const Color secondaryOrange = Color(0xFFFFE0B2);
  static const Color secondaryPurple = Color(0xFFE1BEE7);
  static const Color secondaryPink = Color(0xFFF8BBD0);
  static const Color secondaryTeal = Color(0xFFB2DFDB);
  static const Color secondaryAmber = Color(0xFFFFECB3);
  
  // Get secondary color for a primary color
  static Color getSecondaryColor(Color primary) {
    if (primary == primaryRed) return secondaryRed;
    if (primary == primaryGreen) return secondaryGreen;
    if (primary == primaryBlue) return secondaryBlue;
    if (primary == primaryOrange) return secondaryOrange;
    if (primary == primaryPurple) return secondaryPurple;
    if (primary == primaryPink) return secondaryPink;
    if (primary == primaryTeal) return secondaryTeal;
    if (primary == primaryAmber) return secondaryAmber;
    return Colors.grey[300]!;
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onBackground: AppColors.onBackground,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
    useMaterial3: true,
    fontFamily: 'Adwaita',
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    useMaterial3: true,
    fontFamily: 'Adwaita',
  );
}