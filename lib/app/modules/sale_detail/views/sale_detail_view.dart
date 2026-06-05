import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/currency_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../core/widgets/cyl_badge.dart';
import '../../../data/models/sale_model.dart';
import '../controllers/sale_detail_controller.dart';

class SaleDetailView extends GetView<SaleDetailController> {
  const SaleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: 'Sale Detail',
            sub: 'Transaction overview',
            accent: AppColors.historyGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final sale = controller.sale.value;
              if (sale == null) {
                return const Center(child: Text('Sale not found'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomerCard(sale),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Items'),
                    const SizedBox(height: 8),
                    _buildItemsCard(sale),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Payment Summary'),
                    const SizedBox(height: 8),
                    _buildPaymentCard(context, sale),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final sale = controller.sale.value;
        if (sale == null || sale.dueAmount <= 0) return const SizedBox.shrink();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: ElevatedButton.icon(
              onPressed: () => _showCollectSheet(context, sale),
              icon: const Icon(Icons.account_balance_wallet),
              label: Text('Collect ${sale.dueAmount.toCurrency} Due'),
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

  Widget _buildCustomerCard(Sale sale) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: AppColors.blueBgLight, shape: BoxShape.circle),
              child: const Icon(Icons.person, color: AppColors.blueInk, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sale.customer?.name ?? 'Walk-in Customer',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  if (sale.customer?.phone != null)
                    Text(sale.customer!.phone!,
                        style: const TextStyle(fontSize: 13, color: AppColors.text2Light)),
                  if (sale.customer?.address != null)
                    Text(sale.customer!.address!,
                        style: const TextStyle(fontSize: 13, color: AppColors.text3Light)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('d MMM yyyy').format(DateTime.tryParse(sale.saleDate) ?? DateTime.now()),
                  style: const TextStyle(fontSize: 13, color: AppColors.text3Light, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                _paymentBadge(sale.paymentType),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(Sale sale) {
    final items = sale.items ?? [];
    return Card(
      child: Column(
        children: [
          ...items.map((item) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CylBadge(
                      shortCode: item.cylinder?.shortCode ?? '',
                      color1: Color(int.parse(item.cylinder?.color1?.replaceAll('#', '0xFF') ?? '0xFF2E5BFF')),
                      color2: Color(int.parse(item.cylinder?.color2?.replaceAll('#', '0xFF') ?? '0xFF6C4DF6')),
                      size: 40,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.cylinder?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          Text('${item.cylinder?.size ?? ''} · ${item.qty} pcs × ${item.unitPrice.toCurrency}',
                              style: const TextStyle(fontSize: 13, color: AppColors.text2Light)),
                        ],
                      ),
                    ),
                    Text(
                      (item.qty * item.unitPrice).toCurrency,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Sale sale) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(context, 'Total Amount',
                sale.totalAmount.toCurrency,
                bold: true),
            _divider(context),
            _row(context, 'Paid Amount',
                sale.paidAmount.toCurrency,
                color: AppColors.green),
            if (sale.dueAmount > 0) ...[
              _divider(context),
              _row(context, 'Remaining Due',
                  sale.dueAmount.toCurrency,
                  color: AppColors.red, bold: true),
            ],
            if (sale.notes != null && sale.notes!.isNotEmpty) ...[
              _divider(context),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Note: ${sale.notes}',
                    style: TextStyle(
                        fontSize: 13, color: context.text2Color)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value,
      {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  color: context.text2Color,
                  fontWeight: FontWeight.w600)),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
                  color: color)),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) => Divider(height: 1, color: context.lineColor);

  Widget _buildSectionLabel(String text, {BuildContext? ctx}) {
    return Builder(builder: (context) {
      return Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: (ctx ?? context).text3Color,
          letterSpacing: 0.05,
        ),
      );
    });
  }

  Widget _paymentBadge(String type) {
    final color = type == 'cash' ? AppColors.green : (type == 'partial' ? AppColors.orange : AppColors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(99)),
      child: Text(type.toUpperCase(),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
    );
  }

  void _showCollectSheet(BuildContext context, Sale sale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Collect Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Outstanding: ${sale.dueAmount.toCurrency}',
                style: const TextStyle(color: AppColors.text2Light)),
            const SizedBox(height: 20),
            TextField(
              controller: controller.amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount to collect',
                hintText: sale.dueAmount.toStringAsFixed(0),
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: controller.isCollecting.value ? null : controller.collectPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: controller.isCollecting.value
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Confirm Collection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                )),
          ],
        ),
      ),
    );
  }
}
