import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/customer_list_controller.dart';
import '../../sell/controllers/sell_controller.dart';

class CustomerListView extends GetView<CustomerListController> {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: 'Customers',
            sub: 'Your customer base',
            accent: AppColors.homeGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: TextField(
              controller: controller.searchController,
              onChanged: (v) => controller.searchQuery.value = v,
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                prefixIcon: Icon(Icons.search, color: context.text3Color),
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.searchQuery.value = '';
                        },
                      )
                    : const SizedBox.shrink()),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.customers.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: controller.customers.length,
                  itemBuilder: (context, index) {
                    if (index == controller.customers.length - 3) {
                      controller.fetchCustomers(loadMore: true);
                    }
                    return _buildCustomerCard(context, controller.customers[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomerSheet(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Customer', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context, dynamic customer) {
    final hasDue = (customer.totalDue ?? 0.0) > 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.CUSTOMER_DETAIL, arguments: customer.id),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: AppColors.blueBgLight, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    customer.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.blueInk),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    if (customer.phone != null)
                      Text(customer.phone, style: TextStyle(fontSize: 13, color: context.text2Color)),
                  ],
                ),
              ),
              if (hasDue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '৳${(customer.totalDue as double).toStringAsFixed(0)} due',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.red),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: context.text3Color, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.blueBgLight, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.people_outline, color: AppColors.blueInk, size: 30),
          ),
          const SizedBox(height: 16),
          const Text('No customers found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          Builder(builder: (ctx) => Text('Add your first customer below', style: TextStyle(color: ctx.text3Color))),
        ],
      ),
    );
  }

  void _showAddCustomerSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final isSubmitting = false.obs;

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
            const Text('Add Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *', prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined))),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on_outlined))),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: isSubmitting.value
                      ? null
                      : () async {
                          if (nameCtrl.text.trim().isEmpty) return;
                          isSubmitting.value = true;
                          try {
                            final repo = controller.repository;
                            final resp = await repo.addCustomer(nameCtrl.text.trim(), phoneCtrl.text.trim(), addressCtrl.text.trim());
                            if (resp.success) {
                              Get.back();
                              controller.refresh();
                              if (Get.isRegistered<SellController>()) Get.find<SellController>().refresh();
                              Get.snackbar('Added', 'Customer added successfully', snackPosition: SnackPosition.BOTTOM);
                            }
                          } finally {
                            isSubmitting.value = false;
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: isSubmitting.value
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save Customer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                )),
          ],
        ),
      ),
    );
  }
}
