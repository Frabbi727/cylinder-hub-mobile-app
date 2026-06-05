import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/currency_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../core/widgets/cyl_badge.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/customer_response_models.dart';
import '../../../core/values/date_ext.dart';
import '../controllers/customer_detail_controller.dart';

class CustomerDetailView extends GetView<CustomerDetailController> {
  const CustomerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: 'Customer Detail',
            sub: 'Profile and history',
            accent: AppColors.homeGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final customer = controller.customer.value;
              if (customer == null) {
                return const Center(child: Text('Customer not found'));
              }
              return Column(
                children: [
                  _buildProfileHeader(context, customer),
                  _buildSummaryRow(customer),
                  _buildTabBar(context),
                  Expanded(child: _buildTabContent(context)),
                ],
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final customer = controller.customer.value;
        final due = customer?.totalDue ?? 0;
        if (due <= 0) return const SizedBox.shrink();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: ElevatedButton.icon(
              onPressed: () {
                final firstSale = controller.sales.firstWhereOrNull((s) => s.dueAmount > 0);
                if (firstSale != null) Get.toNamed(Routes.SALE_DETAIL, arguments: firstSale.id);
              },
              icon: const Icon(Icons.account_balance_wallet),
              label: Text('Collect ${due.toCurrency} Due'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Customer customer) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.blueBgLight, shape: BoxShape.circle),
            child: Center(
              child: Text(
                customer.name.isNotEmpty ? customer.name.substring(0, 1).toUpperCase() : '?',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.blueInk),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                if (customer.phone != null)
                  Text(customer.phone!, style: TextStyle(color: context.text2Color)),
                if (customer.address != null)
                  Text(customer.address!, style: TextStyle(fontSize: 13, color: context.text3Color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(Customer customer) {
    final due = customer.totalDue ?? 0;
    final revenue = customer.totalRevenue ?? 0.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          _summaryChip('Revenue', revenue.toCurrency, AppColors.blue),
          const SizedBox(width: 10),
          _summaryChip('Outstanding', due.toCurrency, due > 0 ? AppColors.red : AppColors.green),
          const SizedBox(width: 10),
          _summaryChip('Sales', '${controller.sales.length}', AppColors.mint),
        ],
      ),
    );
  }

  Widget _summaryChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.text3Light, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: context.line2Color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _tabOption(context, 0, 'Sales History'),
          _tabOption(context, 1, 'Empties'),
        ],
      ),
    );
  }

  Widget _tabOption(BuildContext context, int index, String label) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTab.value == index;
        return GestureDetector(
          onTap: () => controller.selectedTab.value = index,
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

  Widget _buildTabContent(BuildContext context) {
    return Obx(() {
      if (controller.selectedTab.value == 0) {
        return _buildSalesList(context);
      }
      return _buildEmptiesList(context);
    });
  }

  Widget _buildSalesList(BuildContext context) {
    if (controller.sales.isEmpty) {
      return Center(child: Text('No sales yet', style: TextStyle(color: context.text3Color)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: controller.sales.length,
      itemBuilder: (_, i) {
        final sale = controller.sales[i];
        final statusColor = sale.paymentType == 'cash'
            ? AppColors.green
            : (sale.paymentType == 'partial' ? AppColors.orange : AppColors.red);
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => Get.toNamed(Routes.SALE_DETAIL, arguments: sale.id),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sale.saleDate.toStandardDate,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text('${sale.items?.length ?? 0} item(s)',
                            style: TextStyle(fontSize: 13, color: context.text2Color)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(sale.totalAmount.toCurrency,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(sale.paymentType.toUpperCase(),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptiesList(BuildContext context) {
    if (controller.empties.isEmpty) {
      return Center(child: Text('No empty returns pending', style: TextStyle(color: context.text3Color)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: controller.empties.length,
      itemBuilder: (_, i) {
        final CustomerEmptyBalance b = controller.empties[i];
        final color1 = b.color1 != null ? Color(int.parse(b.color1!.replaceAll('#', '0xFF'))) : AppColors.blue;
        final color2 = b.color2 != null ? Color(int.parse(b.color2!.replaceAll('#', '0xFF'))) : AppColors.blueInk;

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CylBadge(
                  shortCode: b.cylinderName.substring(0, 1),
                  color1: color1,
                  color2: color2,
                  size: 38,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.cylinderName, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${b.cylinderSize} kg', style: TextStyle(fontSize: 12, color: context.text3Color)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${b.pendingQty}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.red)),
                    const Text('PENDING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.text3Light)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
