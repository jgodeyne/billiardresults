import 'package:flutter/material.dart';

/// App theme configuration with light pastel color scheme
/// and billiard-inspired accent colors
class AppTheme {
  // Billiard accent colors
  static const Color billiardBlue = Color(0xFF6B9BD1);
  static const Color billiardRed = Color(0xFFE57373);
  static const Color billiardOrange = Color(0xFF9D4003); // From existing seed color
  
  // Pastel background colors
  static const Color pastelBackground = Color(0xFFFAFAFA);
  static const Color pastelSurface = Color(0xFFFFFFFF);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: billiardOrange,
      brightness: Brightness.light,
      surface: pastelSurface,
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: billiardOrange,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: billiardOrange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
