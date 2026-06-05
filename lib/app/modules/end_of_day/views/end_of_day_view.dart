import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/currency_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../core/widgets/cyl_badge.dart';
import '../../../data/models/allocation_model.dart';
import '../controllers/end_of_day_controller.dart';

class EndOfDayView extends GetView<EndOfDayController> {
  const EndOfDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          VibrantAppBar(
            title: 'End of Day',
            sub: DateTime.now().toLocal().toString().split(' ')[0], // TODO: Format date nicely
            accent: AppColors.eodGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.allocations.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.allocations.isEmpty && controller.reconciledIds.isEmpty) {
                return _buildNoAllocations();
              }
              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoBanner(),
                      const SizedBox(height: 20),
                      _buildCashAccountabilityCard(),
                      const SizedBox(height: 24),
                      if (controller.allocations.isNotEmpty) ...[
                        ...controller.allocations.map((a) => _buildAllocationCard(a)),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE5C4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFFE67E22), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Reconcile each allocation by confirming sold qty and cash collected. This cannot be undone.',
              style: TextStyle(color: Color(0xFF8A5A2E), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashAccountabilityCard() {
    return Obx(() {
      final s = controller.stats.value;
      final totalFromSales = controller.totalFromAllocations.value;
      final total = controller.totalExpectedCash;
      final cardColor = Get.isDarkMode ? AppColors.surfaceDark : Colors.white;
      final titleColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
      final subColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, color: AppColors.greenInk, size: 18),
                const SizedBox(width: 8),
                Text('Today\'s Cash Accountability',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800, color: titleColor)),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatRow('From today\'s cylinder sales', totalFromSales,
                color: Get.isDarkMode ? AppColors.text2Dark : AppColors.text2Light),
            _buildStatRow('Today\'s dues (to collect later)', s?.todayDueAmount ?? 0,
                color: AppColors.orangeInk),
            _buildStatRow(
                'Pending due collections (${controller.pendingCollections.length})',
                s?.pendingDueCollections ?? 0,
                color: AppColors.greenInk),
            Divider(
                height: 24,
                color: Get.isDarkMode ? AppColors.lineDark : AppColors.lineLight),
            _buildStatRow('Total cash to hand in', total, isTotal: true),
            const SizedBox(height: 16),
            _buildOutstandingWarning(s?.totalOutstandingDues ?? 0),
            if (controller.pendingCollections.isNotEmpty)
              _buildPendingCollectionsTrigger(subColor),
          ],
        ),
      );
    });
  }

  Widget _buildStatRow(String label, double value, {Color? color, bool isTotal = false}) {
    final defaultColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isTotal ? 15 : 13,
                  fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
                  color: color ?? defaultColor)),
          Text(value.toCurrency,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
                  color: color ?? defaultColor)),
        ],
      ),
    );
  }

  Widget _buildOutstandingWarning(double amount) {
    if (amount <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE74C3C), size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Your outstanding (your customers only)',
                style: TextStyle(color: Color(0xFFC0392B), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          Text(amount.toCurrency, style: const TextStyle(color: Color(0xFFC0392B), fontSize: 13, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildPendingCollectionsTrigger(Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: () {
          // Show list of pending collections in a bottom sheet or dialog
          Get.bottomSheet(
            _buildPendingCollectionsList(),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
        },
        child: Row(
          children: [
            Icon(Icons.arrow_right, color: color),
            Text(
                'View ${controller.pendingCollections.length} pending collections to submit',
                style: TextStyle(
                    fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingCollectionsList() {
    final titleColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    final subColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
    final cardColor = Get.isDarkMode ? AppColors.surfaceDark : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pending Due Collections',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: titleColor)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: controller.pendingCollections.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final c = controller.pendingCollections[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(c.customer?.name ?? 'Customer',
                      style: TextStyle(fontWeight: FontWeight.w700, color: titleColor)),
                  subtitle: Text(c.collectionDate,
                      style: TextStyle(fontSize: 12, color: subColor)),
                  trailing: Text(c.amount.toCurrency,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, color: AppColors.greenInk)),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 46)),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationCard(Allocation a) {
    final c = a.cylinder;
    final cardColor = Get.isDarkMode ? AppColors.surfaceDark : Colors.white;
    final titleColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    final isReconciled = a.isReconciled || controller.reconciledIds.contains(a.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          dividerColor: Colors.transparent,
          textTheme: Theme.of(Get.context!).textTheme.apply(
                bodyColor: titleColor,
                displayColor: titleColor,
              ),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          enabled: !isReconciled,
          leading: c != null
              ? CylBadge(
                  shortCode: c.shortCode ?? '',
                  color1: Color(int.parse(c.color1?.replaceAll('#', '0xFF') ?? '0xFF2E5BFF')),
                  color2: Color(int.parse(c.color2?.replaceAll('#', '0xFF') ?? '0xFF6C4DF6')),
                  size: 44,
                )
              : const CircleAvatar(backgroundColor: Colors.grey, radius: 22),
          title: Text(c?.name ?? 'Allocation #${a.id}',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: titleColor)),
          subtitle: Text('${(a.salePrice as num).toCurrency}/pcs', style: const TextStyle(fontSize: 13, color: AppColors.greenInk, fontWeight: FontWeight.w700)),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMiniStat(a.qty.toString(), 'Allocated'),
                  const SizedBox(width: 8),
                  _buildMiniStat(a.soldQty.toString(), 'Sold', color: AppColors.greenInk),
                  const SizedBox(width: 8),
                  _buildMiniStat((isReconciled ? a.returnedQty : (a.qty - a.soldQty)).toString(), isReconciled ? 'Returned' : 'To Return', color: const Color(0xFFD35400)),
                ],
              ),
              const SizedBox(height: 2),
              isReconciled
                  ? _buildStatusBadge('Reconciled', AppColors.greenBgLight, AppColors.greenInk)
                  : _buildReconcileButtonTrigger(),
            ],
          ),
          children: isReconciled
              ? []
              : [
            const Divider(height: 1, color: Color(0xFFEEEEEE), indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reconcile: ${c?.name ?? 'Allocation'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50))),
                  const SizedBox(height: 16),
                  _buildAllocationHeaderStats(a),
                  const SizedBox(height: 24),
                  _buildFormInputs(a),
                  const SizedBox(height: 24),
                  _buildAutomaticCalculation(a),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.reconcile(a),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13696D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Review & Submit →',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildMiniStat(String value, String label, {Color? color}) {
    final defaultColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    final labelColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: color ?? defaultColor)),
        Text(label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w600, color: labelColor)),
      ],
    );
  }

  Widget _buildReconcileButtonTrigger() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF13696D), borderRadius: BorderRadius.circular(6)),
      child: const Text('Reconcile', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildAllocationHeaderStats(Allocation a) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      children: [
        _buildLargeStat(a.qty.toString(), 'Allocated'),
        _buildLargeStat(a.soldQty.toString(), 'Sold', color: AppColors.greenInk),
        _buildLargeStat((a.salePrice as num).toCurrency, 'Price/pcs'),
        _buildLargeStat((a.cashCollectedActual ?? 0).toCurrency, 'Customers paid', color: AppColors.greenInk),
        _buildLargeStat((a.dueFromSales ?? 0).toCurrency, 'Due (credit given)', color: const Color(0xFFD35400)),
      ],
    );
  }

  Widget _buildLargeStat(String value, String label, {Color? color}) {
    final defaultColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    final labelColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color ?? defaultColor)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: labelColor)),
      ],
    );
  }

  Widget _buildFormInputs(Allocation a) {
    final labelColor = Get.isDarkMode ? AppColors.text2Dark : AppColors.text2Light;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How many did you sell? *',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: labelColor)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.soldQtyControllers[a.id],
                keyboardType: TextInputType.number,
                style: TextStyle(color: Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light),
                decoration: InputDecoration(
                  hintText: '0',
                  helperText: 'Max: ${a.qty} · Price: ${(a.salePrice as num).toCurrency}/pcs',
                  helperStyle: const TextStyle(fontSize: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cash submitted ৳ *',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: labelColor)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.collectedAmountControllers[a.id],
                keyboardType: TextInputType.number,
                style: TextStyle(color: Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light),
                decoration: InputDecoration(
                  hintText: '0.00',
                  helperText: 'Collected: ${(a.cashCollectedActual ?? 0).toCurrency} · Due: ${(a.dueFromSales ?? 0).toCurrency}',
                  helperStyle: const TextStyle(fontSize: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutomaticCalculation(Allocation a) {
    final labelColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Automatic calculation:',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: labelColor)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                controller.updateTrigger.value; // Force rebuild on text change
                final sold = controller.soldQtyControllers[a.id]?.text ?? '0';
                return _buildCalcBox(sold, 'Sold ✓', color: AppColors.greenBgLight, textColor: AppColors.greenInk);
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() {
                controller.updateTrigger.value; // Force rebuild on text change
                final toReturn = controller.getToReturn(a);
                return _buildCalcBox(toReturn.toString(), 'Return to warehouse', color: const Color(0xFFFFF4E5), textColor: const Color(0xFFD35400));
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() {
                controller.updateTrigger.value; // Force rebuild on text change
                final sold = int.tryParse(controller.soldQtyControllers[a.id]?.text ?? '0') ?? 0;
                final toReturn = controller.getToReturn(a);
                final total = sold + toReturn;
                return _buildCalcBox(total.toString(), '$sold + $toReturn = $total', color: const Color(0xFFEEF2F6), textColor: const Color(0xFF13696D), showIcon: true);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalcBox(String value, String label, {required Color color, required Color textColor, bool showIcon = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showIcon) ...[
                const Icon(Icons.check, size: 16, color: Color(0xFF13696D)),
                const SizedBox(width: 4),
              ],
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor)),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: textColor), textAlign: TextAlign.center),
        ],
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
    final titleColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    final subColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
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
          Text('All done!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: titleColor)),
          Text('No pending allocations to reconcile.', style: TextStyle(color: subColor)),
        ],
      ),
    );
  }
}
