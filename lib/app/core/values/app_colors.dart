import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Vibrant Palette from Design)
  static const Color blue = Color(0xFF2E5BFF);
  static const Color blueDark = Color(0xFF1E40D8);
  static const Color blueLight = Color(0xFFE7ECFF);
  static const Color blueLine = Color(0xFFCBD8FF);
  static const Color blueInk = Color(0xFF2347D8);
  
  static const Color mint = Color(0xFF00B8A9);
  static const Color mintDark = Color(0xFF029488);
  static const Color mintInk = Color(0xFF067F76);
  
  static const Color orange = Color(0xFFFF7A45);
  static const Color orangeDark = Color(0xFFE85F2A);
  static const Color orangeInk = Color(0xFFC2410C);
  
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleDark = Color(0xFF6A28D8);
  static const Color purpleInk = Color(0xFF6A28D8);
  
  static const Color green = Color(0xFF16A34A);
  static const Color greenDark = Color(0xFF0F7A37);
  static const Color greenInk = Color(0xFF0F7A37);
  
  static const Color red = Color(0xFFEF4444);
  static const Color redDark = Color(0xFFD32F2F);
  static const Color redInk = Color(0xFFC0362B);
  
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberInk = Color(0xFFB7791F);
  
  static const Color pink = Color(0xFFEC4899);
  static const Color pinkInk = Color(0xFFDB3A88);
  
  static const Color navy = Color(0xFF11151F);

  // Surface Colors - Light
  static const Color bgLight = Color(0xFFF4F6FB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surface2Light = Color(0xFFF4F6FB);
  static const Color lineLight = Color(0xFFE6EAF2);
  static const Color line2Light = Color(0xFFEEF1F7);
  static const Color text1Light = Color(0xFF141925);
  static const Color text2Light = Color(0xFF5A6376);
  static const Color text3Light = Color(0xFF939CB0);

  // Surface Colors - Dark
  static const Color bgDark = Color(0xFF0D1017);
  static const Color surfaceDark = Color(0xFF171C26);
  static const Color surface2Dark = Color(0xFF1F2632);
  static const Color lineDark = Color(0xFF2A313F);
  static const Color line2Dark = Color(0xFF232A37);
  static const Color text1Dark = Color(0xFFEEF1F7);
  static const Color text2Dark = Color(0xFFA4AEC2);
  static const Color text3Dark = Color(0xFF6E788C);

  // Tint Backgrounds - Light (used for chip/pill backgrounds)
  static const Color blueBgLight = Color(0xFFE7ECFF);
  static const Color mintBgLight = Color(0xFFD2F4F0);
  static const Color orangeBgLight = Color(0xFFFFE7DB);
  static const Color purpleBgLight = Color(0xFFEDE4FF);
  static const Color greenBgLight = Color(0xFFDCFAE8);
  static const Color redBgLight = Color(0xFFFCE4E4);
  static const Color amberBgLight = Color(0xFFFCEFCD);
  static const Color pinkBgLight = Color(0xFFFCE2EF);

  // Gradients (135deg equivalent)
  static const LinearGradient homeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D6BFF), Color(0xFF6C4DF6)],
  );

  static const LinearGradient historyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0FC2B2), Color(0xFF0B8FA8)],
  );

  static const LinearGradient duesGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A4B), Color(0xFFF2563E)],
  );

  static const LinearGradient reportsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8E54F0), Color(0xFF6A28D8)],
  );

  static const LinearGradient eodGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B6CFF), Color(0xFF7C3AED)],
  );

  static const LinearGradient vibrantBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D6BFF), Color(0xFF2546E0)],
  );
  
  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF16C7B8), Color(0xFF009E90)],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A5B), Color(0xFFF2632E)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF28B866), Color(0xFF138A40)],
  );

  static const LinearGradient sellFabGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue, purple],
  );

  // Status Aliases
  static const Color error = red;
  static const Color success = green;
  static const Color warning = orange;

  static const Color white = Colors.white;
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white82 = Color(0xD1FFFFFF);
  static const Color black18 = Color(0x2E000000);
  static const Color black45 = Color(0x73000000);
  static const Color black15 = Color(0x26000000);
  static const Color shadowColor = Color(0x0F141C26);
  static const Color yellowDot = Color(0xFFFFE08A);
}
