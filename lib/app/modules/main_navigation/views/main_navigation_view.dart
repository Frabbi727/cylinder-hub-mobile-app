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
      const ProfileView(),
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
          final theme = Theme.of(context).bottomNavigationBarTheme;
          
          return Container(
            height: 85,
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, 0, Icons.home_outlined, TranslationKeys.myDay.tr),
                _buildNavItem(context, 1, Icons.receipt_long_outlined, TranslationKeys.sales.tr),
                _buildSellItem(2),
                _buildNavItem(context, 3, Icons.account_balance_wallet_outlined, TranslationKeys.dues.tr),
                _buildNavItem(context, 4, Icons.person_outline, TranslationKeys.profile.tr),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final isSelected = controller.currentIndex == index;
    final color = isSelected ? theme.selectedItemColor : theme.unselectedItemColor;

    return InkWell(
      onTap: () => controller.changeIndex(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellItem(int index) {
    final isSelected = controller.currentIndex == index;
    
    return InkWell(
      onTap: () => controller.changeIndex(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 4),
          Text(
            TranslationKeys.sell.tr,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
