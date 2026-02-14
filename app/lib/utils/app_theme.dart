import 'package:flutter/material.dart';

/// App theme configuration with light pastel color scheme
/// and billiard-inspired accent colors
class AppTheme {
  // Billiard accent colors
  static const Color billiardBlue = Color(0xFF6B9BD1); // Light blue - main color
  static const Color billiardRed = Color(0xFFE57373);
  static const Color billiardOrange = Color(0xFFFFB74D); // Lighter orange
  
  // Pastel background colors
  static const Color pastelBackground = Color(0xFFFAFAFA);
  static const Color pastelSurface = Color(0xFFFFFFFF);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: billiardBlue, // Light blue as primary
      brightness: Brightness.light,
      surface: pastelSurface,
      primary: billiardBlue,
    ),
    scaffoldBackgroundColor: pastelBackground,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: billiardBlue,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: billiardBlue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: billiardBlue,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
