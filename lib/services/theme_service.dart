import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Default to light mode for main app
  bool _readingDarkMode = false; // Separate dark mode for reading sections

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isReadingDarkMode => _readingDarkMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void toggleReadingDarkMode() {
    _readingDarkMode = !_readingDarkMode;
    notifyListeners();
  }

  void setSystem() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  // Get reading theme based on reading dark mode setting
  ThemeData getReadingTheme() {
    if (_readingDarkMode) {
      return _getReadingDarkTheme();
    } else {
      return _getReadingLightTheme();
    }
  }

  // Reading light theme
  ThemeData _getReadingLightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(fontSize: 13, color: Colors.black87),
        bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

  // Reading dark theme
  ThemeData _getReadingDarkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(fontSize: 13, color: Colors.white70),
        bodySmall: TextStyle(fontSize: 12, color: Colors.white60),
      ),
    );
  }
}
