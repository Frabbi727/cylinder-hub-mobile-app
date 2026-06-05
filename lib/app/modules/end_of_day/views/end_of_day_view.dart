import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/currency_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../core/widgets/cyl_badge.dart';
import '../controllers/end_of_day_controller.dart';

class EndOfDayView extends GetView<EndOfDayController> {
  const EndOfDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: 'End of Day',
            sub: 'Submit your daily reconciliation',
            accent: AppColors.eodGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.allocations.isEmpty && controller.reconciledIds.isEmpty) {
                return _buildNoAllocations();
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCashAccountabilityCard(),
                    const SizedBox(height: 20),
                    if (controller.allocations.isNotEmpty) ...[
                      _buildSectionLabel('Pending Reconciliation'),
                      const SizedBox(height: 10),
                      ...controller.allocations.map((a) => _buildAllocationCard(a)),
                    ],
                    if (controller.reconciledIds.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSectionLabel('Completed'),
                      const SizedBox(height: 8),
                      _buildReconciledBadge(),
                    ],
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

  Widget _buildCashAccountabilityCard() {
    return Obx(() {
      final total = controller.totalExpectedCash;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.eodGradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Cash to Hand In',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text((total as num).toCurrency,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAllocationCard(dynamic allocation) {
    final c = allocation.cylinder;
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (c != null)
                  CylBadge(
                    shortCode: c.shortCode ?? '',
                    color1: Color(int.parse(c.color1?.replaceAll('#', '0xFF') ?? '0xFF2E5BFF')),
                    color2: Color(int.parse(c.color2?.replaceAll('#', '0xFF') ?? '0xFF6C4DF6')),
                    size: 40,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c?.name ?? 'Allocation #${allocation.id}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      Text('${allocation.qty} allocated · ${(allocation.salePrice as num).toCurrency} / pc',
                          style: const TextStyle(fontSize: 13, color: AppColors.text2Light)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sold Qty', style: TextStyle(fontSize: 12, color: AppColors.text3Light, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controller.soldQtyControllers[allocation.id],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          suffixText: 'pcs',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cash Collected', style: TextStyle(fontSize: 12, color: AppColors.text3Light, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controller.collectedAmountControllers[allocation.id],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          prefixText: '৳',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.reconcile(allocation),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit Reconciliation', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReconciledBadge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenBgLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greenInk.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.greenInk),
          const SizedBox(width: 10),
          Text(
            '${controller.reconciledIds.length} allocation(s) reconciled today',
            style: const TextStyle(color: AppColors.greenInk, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAllocations() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.greenBgLight, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.check_circle_outline, color: AppColors.greenInk, size: 30),
          ),
          const SizedBox(height: 16),
          const Text('All done!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const Text('No pending allocations to reconcile.', style: TextStyle(color: AppColors.text3Light)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text3Light, letterSpacing: 0.05),
    );
  }
}
