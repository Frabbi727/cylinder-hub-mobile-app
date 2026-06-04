import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
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
                  _buildSectionLabel('Customers'),
                  const SizedBox(height: 7),
                  _buildCustomerSelector(),
                  const SizedBox(height: 24),
                  
                  _buildSectionLabel('Cylinder Types'),
                  const SizedBox(height: 10),
                  _buildCylinderItems(),
                  const SizedBox(height: 12),
                  _buildAddCylinderButton(),
                  
                  const SizedBox(height: 24),
                  _buildSectionLabel('Payment Type'),
                  const SizedBox(height: 7),
                  _buildPaymentTypeSelector(),
                  
                  const SizedBox(height: 24),
                  _buildSectionLabel('Order Summary'),
                  const SizedBox(height: 10),
                  _buildOrderSummary(),
                  
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: controller.recordSale,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(TranslationKeys.recordSale.tr),
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle_outline, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.text2Light,
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
        controller.selectedCustomer.value = controller.customers.firstWhereOrNull((c) => c.id == val);
      },
    ));
  }

  Widget _buildCylinderItems() {
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
                          const Text('Qty', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.text3Light)),
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
                          const Text('Price ৳', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.text3Light)),
                          const SizedBox(height: 5),
                          TextFormField(
                            initialValue: item['unit_price'].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              controller.selectedCylinders[i]['unit_price'] = double.tryParse(val) ?? 0;
                            },
                            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
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
            onPressed: () {
              if (controller.selectedCylinders[index]['qty'] > 1) {
                controller.selectedCylinders[index]['qty']--;
                controller.selectedCylinders.refresh();
              }
            },
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
            onPressed: () {
              controller.selectedCylinders[index]['qty']++;
              controller.selectedCylinders.refresh();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddCylinderButton() {
    return InkWell(
      onTap: () {
        if (controller.cylinders.isNotEmpty) {
          controller.addCylinderItem(controller.cylinders.first);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.blue, width: 1.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.blue, size: 20),
            SizedBox(width: 8),
            Text('Add Item', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.line2Light,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Obx(() => Row(
        children: [
          _buildPaymentOption('cash', TranslationKeys.cash.tr, AppColors.green),
          _buildPaymentOption('partial', TranslationKeys.partial.tr, AppColors.orange),
          _buildPaymentOption('due', 'Due Later', AppColors.red),
        ],
      )),
    );
  }

  Widget _buildPaymentOption(String type, String label, Color activeColor) {
    final isSelected = controller.paymentType.value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.paymentType.value = type,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected ? [const BoxShadow(color: AppColors.black15, blurRadius: 2, offset: Offset(0, 1))] : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : AppColors.text2Light,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Obx(() {
      double total = 0;
      for (var item in controller.selectedCylinders) {
        total += (item['qty'] as int) * (item['unit_price'] as double);
      }
      
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSummaryRow('Total', '৳${total.toStringAsFixed(0)}', isBold: true),
              const SizedBox(height: 10),
              if (controller.paymentType.value == 'partial') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount Paid', style: TextStyle(color: AppColors.text2Light)),
                    SizedBox(
                      width: 100,
                      height: 35,
                      child: TextFormField(
                        controller: controller.paidAmountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0)),
                        onChanged: (_) => controller.update(), // Refresh UI for remaining due
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              _buildSummaryRow(
                'due after this sale', 
                '৳${(total - (double.tryParse(controller.paidAmountController.text) ?? 0)).toStringAsFixed(0)}',
                color: AppColors.red,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color ?? AppColors.text2Light)),
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
