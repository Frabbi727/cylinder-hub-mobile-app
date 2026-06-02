import 'package:flutter/material.dart';
import '../values/app_colors.dart';
import '../values/app_sizes.dart';

class AppTheme {
  static final light = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBg,
    useMaterial3: true,
    brightness: Brightness.light,
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: AppSizes.f20,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: AppSizes.f24, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
      titleLarge: TextStyle(fontSize: AppSizes.f20, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
      bodyLarge: TextStyle(fontSize: AppSizes.f16, color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(fontSize: AppSizes.f14, color: AppColors.lightTextSecondary),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.lightCardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.p16)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightCardBg,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.lightTextSecondary,
      elevation: 10,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.p12), borderSide: const BorderSide(color: AppColors.lightBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.p12), borderSide: const BorderSide(color: AppColors.lightBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.p12), borderSide: const BorderSide(color: AppColors.primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p12),
    ),
  );

  static final dark = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBg,
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: AppSizes.f20,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: AppSizes.f24, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary),
      titleLarge: TextStyle(fontSize: AppSizes.f20, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary),
      bodyLarge: TextStyle(fontSize: AppSizes.f16, color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(fontSize: AppSizes.f14, color: AppColors.darkTextSecondary),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.darkCardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.p16)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCardBg,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.darkTextSecondary,
      elevation: 10,
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.p12), borderSide: const BorderSide(color: AppColors.darkBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.p12), borderSide: const BorderSide(color: AppColors.darkBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.p12), borderSide: const BorderSide(color: AppColors.primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p12),
    ),
  );
}
