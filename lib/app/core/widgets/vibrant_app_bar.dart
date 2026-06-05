import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../values/app_colors.dart';

class VibrantAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? sub;
  final String? kicker;
  final LinearGradient? accent;
  final bool curve;
  final bool tall;
  final Widget? child;
  final VoidCallback? onBell;
  final VoidCallback? onBack;
  final bool showThemeToggle;

  const VibrantAppBar({
    super.key,
    required this.title,
    this.sub,
    this.kicker,
    this.accent,
    this.curve = false,
    this.tall = false,
    this.child,
    this.onBell,
    this.onBack,
    this.showThemeToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        bottom: tall ? 10 : 16,
      ),
      decoration: BoxDecoration(
        gradient: accent ?? AppColors.vibrantBlueGradient,
        borderRadius: curve ? const BorderRadius.vertical(bottom: Radius.circular(28)) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: onBack,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 18, color: AppColors.white),
                    SizedBox(width: 4),
                    Text(
                      'Back', 
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kicker != null)
                      Text(
                        kicker!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white70,
                          letterSpacing: 0.04,
                        ),
                      ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        letterSpacing: -0.01,
                      ),
                    ),
                    if (sub != null)
                      Text(
                        sub!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (showThemeToggle)
                    _buildHeaderBtn(
                      icon: isDark ? Icons.light_mode : Icons.dark_mode,
                      onPressed: () {
                        Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
                        GetStorage().write('isDarkMode', !isDark);
                      },
                      ghost: true,
                    ),
                  if (showThemeToggle && onBell != null) const SizedBox(width: 7),
                  if (onBell != null)
                    _buildHeaderBtn(
                      icon: Icons.notifications,
                      onPressed: onBell!,
                      hasBadge: true,
                    ),
                ],
              ),
            ],
          ),
          if (child != null) child!,
        ],
      ),
    );
  }

  Widget _buildHeaderBtn({
    required IconData icon,
    required VoidCallback onPressed,
    bool ghost = false,
    bool hasBadge = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: ghost ? 0.18 : 0.16),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: 19),
            if (hasBadge)
              Positioned(
                top: 9,
                right: 9,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.yellowDot,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.black15, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(tall ? 200 : 160);
}
