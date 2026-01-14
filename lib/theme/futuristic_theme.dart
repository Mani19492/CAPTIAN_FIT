import 'package:flutter/material.dart';

class FuturisticTheme {
  // Primary colors inspired by the Captain Fit logo
  static const Color primaryRed = Color(0xFFFF4757);
  static const Color primaryDarkRed = Color(0xFFEE5A6F);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentPurple = Color(0xFF6C5CE7);
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color darkCardBg = Color(0xFF1A1F3A);
  static const Color darkCardBg2 = Color(0xFF16213E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B5C1);
  static const Color borderColor = Color(0xFF2D3561);
  static const Color successGreen = Color(0xFF00D97E);
  static const Color warningOrange = Color(0xFFFFB800);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCardBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryRed,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryRed,
        secondary: accentCyan,
        surface: darkCardBg,
        error: primaryRed,
        brightness: Brightness.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardBg2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentCyan, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondary),
        labelStyle: const TextStyle(color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkCardBg.withOpacity(0.7),
        elevation: 0,
        indicatorColor: primaryRed.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? const TextStyle(color: primaryRed, fontWeight: FontWeight.bold)
              : const TextStyle(color: textSecondary),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
      ),
    );
  }
}
