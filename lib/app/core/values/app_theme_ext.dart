import 'package:flutter/material.dart';
import 'app_colors.dart';

extension AppThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get text1Color => isDark ? AppColors.text1Dark : AppColors.text1Light;
  Color get text2Color => isDark ? AppColors.text2Dark : AppColors.text2Light;
  Color get text3Color => isDark ? AppColors.text3Dark : AppColors.text3Light;
  Color get lineColor => isDark ? AppColors.lineDark : AppColors.lineLight;
  Color get line2Color => isDark ? AppColors.line2Dark : AppColors.line2Light;
  Color get surfaceColor => isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get bgColor => isDark ? AppColors.bgDark : AppColors.bgLight;
}
