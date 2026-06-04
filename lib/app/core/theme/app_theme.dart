import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class AppTheme {
  static const double rCard = 18.0;
  static const double rCtrl = 13.0;

  static final light = ThemeData(
    primaryColor: AppColors.blue,
    scaffoldBackgroundColor: AppColors.bgLight,
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.01,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: AppColors.text1Light, letterSpacing: -0.025),
      displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.text1Light, letterSpacing: -0.02),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text1Light, letterSpacing: -0.01),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.text1Light, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.text2Light, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.text3Light, fontWeight: FontWeight.w700, letterSpacing: 0.05),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 1,
      shadowColor: const Color(0xFF141C26).withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rCard)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.blue,
      unselectedItemColor: AppColors.text3Light,
      elevation: 10,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(rCtrl), borderSide: const BorderSide(color: AppColors.lineLight, width: 1.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rCtrl), borderSide: const BorderSide(color: AppColors.lineLight, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rCtrl), borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: const TextStyle(color: AppColors.text3Light, fontSize: 16),
      labelStyle: const TextStyle(color: AppColors.text2Light, fontSize: 13, fontWeight: FontWeight.w700),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rCtrl)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        elevation: 4,
        shadowColor: AppColors.blue.withValues(alpha: 0.32),
      ),
    ),
  );

  static final dark = ThemeData(
    primaryColor: AppColors.blue,
    scaffoldBackgroundColor: AppColors.bgDark,
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.01,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: AppColors.text1Dark, letterSpacing: -0.025),
      displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.text1Dark, letterSpacing: -0.02),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text1Dark, letterSpacing: -0.01),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.text1Dark, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.text2Dark, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.text3Dark, fontWeight: FontWeight.w700, letterSpacing: 0.05),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rCard)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.blue,
      unselectedItemColor: AppColors.text3Dark,
      elevation: 10,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(rCtrl), borderSide: const BorderSide(color: AppColors.lineDark, width: 1.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rCtrl), borderSide: const BorderSide(color: AppColors.lineDark, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rCtrl), borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: const TextStyle(color: AppColors.text3Dark, fontSize: 16),
      labelStyle: const TextStyle(color: AppColors.text2Dark, fontSize: 13, fontWeight: FontWeight.w700),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rCtrl)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
    ),
  );
}
