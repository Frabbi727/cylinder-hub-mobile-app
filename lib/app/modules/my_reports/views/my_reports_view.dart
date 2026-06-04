import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/my_reports_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

class MyReportsView extends GetView<MyReportsController> {
  const MyReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: TranslationKeys.myReports.tr,
            sub: 'Personal performance overview',
            accent: AppColors.reportsGradient,
            curve: true,
            onBack: () => Get.find<MainNavigationController>().changeIndex(0),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Performance Summary'),
                  const SizedBox(height: 10),
                  Obx(() => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildReportRow('Total Allocated', '${controller.report.value?.totalAllocated ?? 0} pcs'),
                          _buildReportRow('Total Sold', '${controller.report.value?.totalSold ?? 0} pcs'),
                          _buildReportRow('Sell-through', '${((controller.report.value?.sellThroughRate ?? 0) * 100).toStringAsFixed(1)}%'),
                          _buildReportRow('Collection Rate', '${controller.report.value?.collectionRatePct ?? 0}%'),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.text3Light,
        letterSpacing: 0.05,
      ),
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.text2Light, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ],
      ),
    );
  }
}
