import 'package:flutter/material.dart';

class FuturisticTheme {
  static final Color primaryBlue = const Color(0xFF4FC3F7);
  static final Color accentCyan = const Color(0xFF18FFFF);
  static final Color successGreen = const Color(0xFF69F0AE);
  static final Color warningOrange = const Color(0xFFFFD740);
  static final Color primaryRed = const Color(0xFFFF5252);
  static final Color darkBg = const Color(0xFF0A0A0A);
  static final Color darkCardBg = const Color(0xFF1E1E1E);
  static final Color darkCardBg2 = const Color(0xFF2A2A2A);
  static final Color borderColor = const Color(0xFF333333);
  static final Color textPrimary = Colors.white;
  static final Color textSecondary = const Color(0xFFB0B0B0);

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primaryBlue,
      secondary: accentCyan,
      surface: darkCardBg,
      background: darkBg,
    ),
    scaffoldBackgroundColor: darkBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkCardBg,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: darkCardBg,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue),
      ),
    ),
  );
}