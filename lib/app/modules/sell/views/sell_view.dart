import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/currency_ext.dart';
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
    return Obx(() {
      final isCash = controller.paymentType.value == 'cash';
      return DropdownButtonFormField<int>(
        value: controller.selectedCustomer.value?.id,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 18),
          hintText: isCash ? 'Select customer (optional)' : 'Select a registered customer',
        ),
        items: [
          if (isCash)
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
      );
    });
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (item['stock'] as int) < 5 ? AppColors.redBgLight : AppColors.greenBgLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stock: ${item['stock']}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: (item['stock'] as int) < 5 ? AppColors.redInk : AppColors.greenInk,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.red, size: 22),
                      onPressed: () => controller.removeCylinderItem(i),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
                          _buildStepper(i, item['stock'] as int),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: context.text3Color)),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: controller.priceControllers[i],
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: context.line2Color.withValues(alpha: 0.8),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: context.lineColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: context.lineColor),
                              ),
                            ),
                            style: TextStyle(
                              color: context.text1Color, 
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
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

  Widget _buildStepper(int index, int stock) {
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
            child: TextFormField(
              controller: controller.qtyControllers[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (val) {
                final qty = int.tryParse(val) ?? 1;
                controller.updateQty(index, qty);
              },
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.blueDark),
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
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.line2Color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text('Select Cylinder Type',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: available.map((c) {
                  final stock = controller.salesmanQtyFor(c.id);
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.blueBgLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.propane_tank, color: AppColors.blueInk, size: 22),
                    ),
                    title: Text(c.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    subtitle: Row(
                      children: [
                        Text(c.size, style: TextStyle(color: context.text3Color, fontSize: 13)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: stock < 5 ? AppColors.redBgLight : AppColors.blueBgLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Stock: $stock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: stock < 5 ? AppColors.redInk : AppColors.blueInk,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.add_circle, color: AppColors.blue, size: 26),
                    onTap: () {
                      controller.addCylinderItem(c);
                      Get.back();
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
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
              _buildSummaryRow(context, 'Total', total.toCurrency, isBold: true),
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
                    due.toCurrency,
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
