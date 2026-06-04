import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/main_navigation_controller.dart';
import '../../my_day/views/my_day_view.dart';
import '../../sales/views/sales_view.dart';
import '../../sell/views/sell_view.dart';
import '../../dues/views/dues_view.dart';
import '../../profile/views/profile_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const MyDayView(),
      const SalesView(),
      const SellView(),
      const DuesView(),
      const ProfileView(), // Using profile as the "More" tab for now or create a dedicated More view
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        if (controller.currentIndex != 0) {
          controller.changeIndex(0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Obx(() => IndexedStack(
          index: controller.currentIndex,
          children: pages,
        )),
        bottomNavigationBar: Obx(() {
          final isDark = Get.isDarkMode;
          
          return Container(
            height: 88, // nav-h: 66px + padding
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.lineDark : AppColors.lineLight,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  _buildNavItem(context, 0, Icons.home_filled, TranslationKeys.dashboard.tr),
                  _buildNavItem(context, 1, Icons.shopping_cart, TranslationKeys.history.tr),
                  _buildSellItem(2),
                  _buildNavItem(context, 3, Icons.account_balance_wallet, TranslationKeys.dues.tr),
                  _buildNavItem(context, 4, Icons.grid_view_rounded, TranslationKeys.more.tr),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final isSelected = controller.currentIndex == index;
    final color = isSelected ? AppColors.blue : theme.unselectedItemColor;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeIndex(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: color, 
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellItem(int index) {
    final isSelected = controller.currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () => controller.changeIndex(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blue, AppColors.purple],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 26),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -14),
              child: Text(
                TranslationKeys.sell.tr,
                style: TextStyle(
                  color: isSelected ? AppColors.blue : AppColors.text3Light,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
