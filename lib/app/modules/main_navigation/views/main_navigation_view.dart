import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          // If not on 'My Day' tab, go to it
          controller.changeIndex(0);
        } else {
          // If already on 'My Day', exit the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Obx(() => IndexedStack(
          index: controller.currentIndex,
          children: pages,
        )),
      bottomNavigationBar: Obx(() => Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, TranslationKeys.myDay.tr),
            _buildNavItem(1, Icons.receipt_long_outlined, TranslationKeys.sales.tr),
            _buildSellItem(2),
            _buildNavItem(3, Icons.account_balance_wallet_outlined, TranslationKeys.dues.tr),
            _buildNavItem(4, Icons.person_outline, TranslationKeys.profile.tr),
          ],
        ),
      )),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = controller.currentIndex == index;
    final color = isSelected ? const Color(0xFF137D7D) : Colors.grey;

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
              color: const Color(0xFF137D7D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 4),
          Text(
            TranslationKeys.sell.tr,
            style: TextStyle(
              color: isSelected ? const Color(0xFF137D7D) : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
