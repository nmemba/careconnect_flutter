import 'package:flutter/material.dart';

/// App theme configuration matching the React version's design tokens
class AppTheme {
  // Colors from globals.css
  static const Color primaryColor = Color(0xFF2563EB); // blue-600
  static const Color primaryHover = Color(0xFF1D4ED8); // blue-700
  static const Color primaryLight = Color(0xFFEFF6FF); // blue-50
  
  static const Color grayDark = Color(0xFF111827); // gray-900
  static const Color grayMedium = Color(0xFF4B5563); // gray-600
  static const Color grayLight = Color(0xFF9CA3AF); // gray-400
  static const Color grayBorder = Color(0xFFE5E7EB); // gray-200
  static const Color grayBg = Color(0xFFF9FAFB); // gray-50
  
  static const Color errorColor = Color(0xFFDC2626); // red-600
  static const Color errorBg = Color(0xFFFEF2F2); // red-50
  
  static const Color successColor = Color(0xFF16A34A); // green-600
  static const Color warningColor = Color(0xFFEA580C); // orange-600
  
  // Minimum touch target sizes (56x56 dp per guidelines)
  static const double minTouchTarget = 56.0;
  static const double minTouchTargetLandscape = 48.0;
  
  // Spacing
  static const double spacing = 8.0;
  static const double spacingSmall = 4.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 24.0;
  
  // Border radius
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: primaryColor,
        error: errorColor,
        surface: Colors.white,
        background: grayBg,
      ),
      scaffoldBackgroundColor: grayBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: grayDark,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
          side: const BorderSide(color: grayBorder),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXLarge,
            vertical: spacingLarge,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          elevation: 1,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXLarge,
            vertical: spacingLarge,
          ),
          side: const BorderSide(color: grayBorder, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingLarge,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: grayBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: grayBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: grayBg,
        selectedColor: primaryLight,
        labelStyle: const TextStyle(fontSize: 14),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: grayMedium,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
