import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/empty_returns_controller.dart';

class EmptyReturnsView extends GetView<EmptyReturnsController> {
  const EmptyReturnsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: 'Empty Returns',
            sub: 'Return empty cylinders',
            accent: AppColors.mintGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Cylinder Type'),
                    const SizedBox(height: 8),
                    _buildCylinderDropdown(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Customer (Optional)'),
                    const SizedBox(height: 8),
                    _buildCustomerDropdown(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Quantity'),
                    const SizedBox(height: 8),
                    _buildQtyStepper(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Return Date'),
                    const SizedBox(height: 8),
                    _buildDatePicker(context),
                    const SizedBox(height: 20),
                    _buildExtraToggle(),
                    Obx(() => controller.isExtra.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextField(
                              controller: controller.extraReasonController,
                              decoration: const InputDecoration(
                                labelText: 'Reason for extra return *',
                                prefixIcon: Icon(Icons.info_outline),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Notes (Optional)'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Any additional notes...',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: controller.submitReturn,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Submit Return', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCylinderDropdown() {
    return Obx(() => DropdownButtonFormField<int>(
          value: controller.selectedCylinder.value?.id,
          decoration: const InputDecoration(
            hintText: 'Select cylinder type',
            prefixIcon: Icon(Icons.propane_tank_outlined),
          ),
          items: controller.cylinders.map((c) => DropdownMenuItem(value: c.id, child: Text('${c.name} (${c.size})'))).toList(),
          onChanged: (id) {
            controller.selectedCylinder.value = controller.cylinders.firstWhereOrNull((c) => c.id == id);
          },
        ));
  }

  Widget _buildCustomerDropdown() {
    return Obx(() => DropdownButtonFormField<int?>(
          value: controller.selectedCustomer.value?.id,
          decoration: const InputDecoration(
            hintText: 'Select customer (optional)',
            prefixIcon: Icon(Icons.person_outline),
          ),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('No customer')),
            ...controller.customers.map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name))),
          ],
          onChanged: (id) {
            controller.selectedCustomer.value = id == null
                ? null
                : controller.customers.firstWhereOrNull((c) => c.id == id);
          },
        ));
  }

  Widget _buildQtyStepper() {
    return Obx(() => Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Row(
                  children: [
                    _stepperBtn(Icons.remove, controller.decrementQty),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('${controller.qty.value}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                    _stepperBtn(Icons.add, controller.incrementQty),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _stepperBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.blueBgLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.blueInk, size: 20),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              controller.returnDate.value = DateFormat('yyyy-MM-dd').format(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lineLight),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.text3Light, size: 20),
                const SizedBox(width: 12),
                Text(
                  controller.returnDate.value.isEmpty ? 'Select date' : controller.returnDate.value,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildExtraToggle() {
    return Obx(() => Card(
          child: SwitchListTile(
            title: const Text('Extra Return', style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text('Toggle if returning more than allocated', style: TextStyle(fontSize: 12)),
            value: controller.isExtra.value,
            onChanged: (v) => controller.isExtra.value = v,
            activeColor: AppColors.orange,
          ),
        ));
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text3Light, letterSpacing: 0.05),
    );
  }
}
