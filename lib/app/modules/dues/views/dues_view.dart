import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/currency_ext.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/dues_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';
import '../../../routes/app_pages.dart';

class DuesView extends GetView<DuesController> {
  const DuesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: TranslationKeys.dues.tr,
            sub: 'Sales with unpaid amounts',
            accent: AppColors.duesGradient,
            curve: true,
            onBack: () => Get.find<MainNavigationController>().changeIndex(0),
          ),
          _buildSummaryCards(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.overdueCustomers.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: controller.fetchOverdue,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: controller.overdueCustomers.length,
                  itemBuilder: (_, index) {
                    final customer = controller.overdueCustomers[index];
                    return _buildDueCard(context, customer);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() => Row(
        children: [
          _buildSummaryCard('Total Due',
              controller.totalDue.toCurrency, AppColors.red),
          const SizedBox(width: 12),
          _buildSummaryCard('Unpaid Sales',
              '${controller.totalSalesCount}', AppColors.orange),
        ],
      )),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildDueCard(BuildContext context, dynamic customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.blueBgLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.blueInk),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(
                    '${customer.unpaidSalesCount} sale · Oldest: ${customer.oldestDueDate}',
                    style: TextStyle(fontSize: 13, color: context.text2Color),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  (customer.totalDue as num).toCurrency,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.red),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => Get.toNamed(Routes.CUSTOMER_DETAIL,
                      arguments: customer.customerId),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Collect',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.greenBgLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                const Icon(Icons.check_circle_outline, color: AppColors.greenInk, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'All dues collected!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text(
            'Great work. No outstanding payments.',
            style: TextStyle(color: context.text3Color, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
