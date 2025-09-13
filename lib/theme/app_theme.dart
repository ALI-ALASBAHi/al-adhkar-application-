import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color skyBlue500 = Color(0xFF0EA5E9);
  static const Color skyBlue600 = Color(0xFF0284C7);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray800 = Color(0xFF1F2937);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: skyBlue500),
    scaffoldBackgroundColor: gray50,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: const DividerThemeData(color: gray200),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 13, color: Colors.black54),
      bodySmall: TextStyle(fontSize: 12, color: gray400),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: skyBlue600,
      unselectedItemColor: gray400,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: skyBlue500),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111827),
      foregroundColor: Colors.white,
      elevation: 0.5,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1F2937),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF374151)),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 13, color: Colors.white70),
      bodySmall: TextStyle(fontSize: 12, color: Colors.white60),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF111827),
      selectedItemColor: skyBlue500,
      unselectedItemColor: Colors.white60,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),
  );
}


