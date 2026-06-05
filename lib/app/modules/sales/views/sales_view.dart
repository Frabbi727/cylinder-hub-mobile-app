import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../core/widgets/cyl_badge.dart';
import '../controllers/sales_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';
import '../../../routes/app_pages.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: TranslationKeys.sales.tr,
            sub: 'View your sales history',
            accent: AppColors.historyGradient,
            curve: true,
            onBack: () => Get.find<MainNavigationController>().changeIndex(0),
          ),
          _buildPeriodTabs(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.sales.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: controller.fetchSales,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: controller.sales.length,
                  itemBuilder: (_, index) {
                    final sale = controller.sales[index];
                    return _buildSaleCard(context, sale);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTabs(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: context.line2Color,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _buildTabOption(context, 'Today', TranslationKeys.today.tr),
          _buildTabOption(context, 'Week', TranslationKeys.thisWeek.tr),
          _buildTabOption(context, 'Month', TranslationKeys.thisMonth.tr),
        ],
      ),
    );
  }

  Widget _buildTabOption(BuildContext context, String value, String label) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedPeriod.value == value;
        return GestureDetector(
          onTap: () => controller.changePeriod(value),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? context.surfaceColor : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              boxShadow: isSelected
                  ? [BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.06),
                      blurRadius: 2,
                      offset: const Offset(0, 1))]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.mintInk : context.text2Color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSaleCard(BuildContext context, dynamic sale) {
    final statusColor = sale.paymentType == 'cash'
        ? AppColors.green
        : (sale.paymentType == 'partial' ? AppColors.orange : AppColors.red);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.SALE_DETAIL, arguments: sale.id),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CylBadge(
                shortCode: sale.items?.first.cylinder?.shortCode ?? '',
                color1: Color(int.parse(
                    sale.items?.first.cylinder?.color1?.replaceAll('#', '0xFF') ??
                        '0xFF2E5BFF')),
                color2: Color(int.parse(
                    sale.items?.first.cylinder?.color2?.replaceAll('#', '0xFF') ??
                        '0xFF6C4DF6')),
                size: 38,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.customer?.name ?? TranslationKeys.walkIn.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    Text(
                      '${sale.items?.first.qty} × ${sale.items?.first.cylinder?.size} · ${sale.saleDate}',
                      style: TextStyle(
                          fontSize: 13, color: context.text2Color),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '৳${sale.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      sale.paymentType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              color: AppColors.blueBgLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.blueInk, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            TranslationKeys.noData.tr,
            style: TextStyle(
                color: context.text3Color,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
