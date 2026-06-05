import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/sell_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

class SellView extends GetView<SellController> {
  const SellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: TranslationKeys.newSale.tr,
            sub: 'Record a new cylinder sale',
            curve: true,
            onBack: () => Get.find<MainNavigationController>().changeIndex(0),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'Customers'),
                  const SizedBox(height: 7),
                  _buildCustomerSelector(),
                  const SizedBox(height: 24),

                  _buildSectionLabel(context, 'Cylinder Types'),
                  const SizedBox(height: 10),
                  _buildCylinderItems(context),
                  const SizedBox(height: 12),
                  _buildAddCylinderButton(context),

                  const SizedBox(height: 24),
                  _buildSectionLabel(context, 'Payment Type'),
                  const SizedBox(height: 7),
                  _buildPaymentTypeSelector(context),

                  const SizedBox(height: 24),
                  _buildSectionLabel(context, 'Order Summary'),
                  const SizedBox(height: 10),
                  _buildOrderSummary(context),

                  const SizedBox(height: 32),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading ? null : controller.recordSale,
                    child: controller.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(TranslationKeys.recordSale.tr),
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle_outline, size: 20),
                            ],
                          ),
                  )),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: context.text2Color,
      ),
    );
  }

  Widget _buildCustomerSelector() {
    return Obx(() => DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search, size: 18),
        hintText: 'Select customer (optional)',
      ),
      items: [
        DropdownMenuItem<int>(
          value: null,
          child: Text(TranslationKeys.walkIn.tr),
        ),
        ...controller.customers.map((c) => DropdownMenuItem<int>(
          value: c.id,
          child: Text(c.name),
        )),
      ],
      onChanged: (val) {
        controller.selectedCustomer.value =
            controller.customers.firstWhereOrNull((c) => c.id == val);
      },
    ));
  }

  Widget _buildCylinderItems(BuildContext context) {
    return Obx(() => Column(
      children: controller.selectedCylinders.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item['name']} ${item['size']}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.red),
                      onPressed: () => controller.removeCylinderItem(i),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Qty',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: context.text3Color)),
                          const SizedBox(height: 5),
                          _buildStepper(i),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price ৳',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: context.text3Color)),
                          const SizedBox(height: 5),
                          TextFormField(
                            initialValue: item['unit_price'].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (val) =>
                                controller.updatePrice(i, double.tryParse(val) ?? 0),
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildStepper(int index) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.blueBgLight,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18, color: AppColors.blueDark),
            onPressed: () => controller.updateQty(
                index, (controller.selectedCylinders[index]['qty'] as int) - 1),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${controller.selectedCylinders[index]['qty']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18, color: AppColors.blueDark),
            onPressed: () => controller.updateQty(
                index, (controller.selectedCylinders[index]['qty'] as int) + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCylinderButton(BuildContext context) {
    return InkWell(
      onTap: () => _showCylinderPicker(context),
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.blue, width: 1.5),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.blue, size: 20),
            SizedBox(width: 8),
            Text('Add Cylinder Type',
                style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  void _showCylinderPicker(BuildContext context) {
    final available = controller.cylinders
        .where((c) =>
            !controller.selectedCylinders.any((item) => item['cylinder_id'] == c.id))
        .toList();
    if (available.isEmpty) {
      Get.snackbar('All Added', 'All cylinder types are already in the order',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text('Select Cylinder Type',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ),
          ...available.map((c) => ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.blueBgLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.propane_tank, color: AppColors.blueInk, size: 18),
                ),
                title: Text(c.name,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(c.size),
                trailing:
                    const Icon(Icons.add_circle, color: AppColors.blue),
                onTap: () {
                  controller.addCylinderItem(c);
                  Get.back();
                },
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: context.line2Color,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Obx(() => Row(
        children: [
          _buildPaymentOption(context, 'cash', TranslationKeys.cash.tr, AppColors.green),
          _buildPaymentOption(context, 'partial', TranslationKeys.partial.tr, AppColors.orange),
          _buildPaymentOption(context, 'due', 'Due Later', AppColors.red),
        ],
      )),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, String type, String label, Color activeColor) {
    final isSelected = controller.paymentType.value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.paymentType.value = type,
        child: Container(
          height: 44,
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
              color: isSelected ? activeColor : context.text2Color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Obx(() {
      final total = controller.totalAmount;
      final payType = controller.paymentType.value;
      final paidText = controller.paidAmountController.text;
      final paid = double.tryParse(paidText) ?? 0;
      final due = payType == 'cash'
          ? 0.0
          : payType == 'partial'
              ? total - paid
              : total;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSummaryRow(context, 'Total', '৳${total.toStringAsFixed(0)}', isBold: true),
              if (payType == 'partial') ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount Paid',
                        style: TextStyle(color: context.text2Color)),
                    SizedBox(
                      width: 110,
                      height: 35,
                      child: TextFormField(
                        controller: controller.paidAmountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8, vertical: 0)),
                        onChanged: (_) => controller.selectedCylinders.refresh(),
                      ),
                    ),
                  ],
                ),
              ],
              if (due > 0) ...[
                const SizedBox(height: 10),
                _buildSummaryRow(context, 'Due after this sale',
                    '৳${due.toStringAsFixed(0)}',
                    color: AppColors.red),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: color ?? context.text2Color)),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
