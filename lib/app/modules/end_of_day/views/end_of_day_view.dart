import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/currency_ext.dart';
import '../../../core/values/date_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../core/widgets/cyl_badge.dart';
import '../../../data/models/allocation_model.dart';
import '../controllers/end_of_day_controller.dart';

const Color eodPrimary = Color(0xFF0B6E75);
const Color eodSuccess = Color(0xFF176B3A);
const Color eodWarning = Color(0xFFA85200);
const Color eodDanger = Color(0xFFB83030);
const Color eodTextPrimary = Color(0xFF111827);
const Color eodTextMuted = Color(0xFF6B7280);

class EndOfDayView extends GetView<EndOfDayController> {
  const EndOfDayView({super.key});

  String _formatShortDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          VibrantAppBar(
            title: 'End of Day',
            sub: DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
            accent: AppColors.eodGradient,
            curve: true,
            onBack: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.allocations.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.allocations.isEmpty) {
                return _buildNoAllocations();
              }

              // Show All Done screen if all allocations are reconciled
              final allReconciled = controller.allocations.isNotEmpty &&
                  controller.allocations.every((a) => a.isReconciled || controller.reconciledIds.contains(a.id));
              
              if (allReconciled) {
                return _buildAllDoneScreen();
              }

              final today = DateTime.now().toLocal().toApiDate;
              final hasOverdue = controller.allocations.any((a) =>
                  a.allocationDate.compareTo(today) < 0 &&
                  !(a.isReconciled || controller.reconciledIds.contains(a.id)));

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoBanner(),
                      const SizedBox(height: 12),
                      if (hasOverdue) ...[
                        _buildOverdueBanner(),
                        const SizedBox(height: 12),
                      ],
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
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: const Border(left: BorderSide(color: AppColors.amber, width: 4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.amber, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Reconcile each allocation by confirming sold qty, empty returns, and cash collected. This cannot be undone.',
              style: TextStyle(color: AppColors.amberInk, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverdueBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3),
        borderRadius: BorderRadius.circular(10),
        border: const Border(left: BorderSide(color: AppColors.redInk, width: 4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.redInk, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Overdue: You have unreconciled allocations from previous days. Please reconcile them below.',
              style: TextStyle(color: AppColors.redInk, fontSize: 12, fontWeight: FontWeight.bold),
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
              separatorBuilder: (_, _) => const Divider(),
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
    final today = DateTime.now().toLocal().toApiDate;
    final isOverdue = a.allocationDate.compareTo(today) < 0 && !isReconciled;

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
          controller: controller.tileControllers.putIfAbsent(a.id, () => ExpansionTileController()),
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c?.name ?? 'Allocation #${a.id}',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: titleColor)),
              if (isOverdue) ...[
                const SizedBox(height: 2),
                Text(
                  '⚠ From ${_formatShortDate(a.allocationDate)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.redInk, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
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
              child: Obx(() {
                final step = controller.allocationSteps[a.id] ?? 'form';
                if (step == 'confirming') {
                  return _buildConfirmStepView(a);
                }
                return _buildFormInputsStepView(a);
              }),
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
      decoration: BoxDecoration(color: eodPrimary, borderRadius: BorderRadius.circular(6)),
      child: const Text('Reconcile', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildFormInputsStepView(Allocation a) {
    final c = a.cylinder;
    final labelColor = Get.isDarkMode ? AppColors.text2Dark : AppColors.text2Light;
    final subColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reconcile: ${c?.name ?? ''} ${c?.size ?? ''}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50))),
        const SizedBox(height: 16),
        _buildAllocationHeaderStats(a),
        const SizedBox(height: 24),
        Obx(() {
          controller.updateTrigger.value; // register updates

          final soldText = controller.soldQtyControllers[a.id]?.text ?? '';
          final soldQty = int.tryParse(soldText);
          String? soldError;
          if (soldText.isEmpty) {
            soldError = 'Please enter how many you sold.';
          } else if (soldQty == null) {
            soldError = 'Invalid number';
          } else if (soldQty > a.qty) {
            soldError = 'Cannot exceed allocated (${a.qty}).';
          } else if (soldQty < 0) {
            soldError = 'Quantity cannot be negative.';
          }

          final cashText = controller.collectedAmountControllers[a.id]?.text ?? '';
          final cash = double.tryParse(cashText);
          String? cashError;
          if (cashText.isEmpty) {
            cashError = 'Please enter the cash amount.';
          } else if (cash == null) {
            cashError = 'Invalid amount';
          } else if (cash < 0) {
            cashError = 'Cash cannot be negative.';
          }

          final hasFormErrors = soldError != null || cashError != null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            errorText: soldError,
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
                            errorText: cashError,
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
              ),
              const SizedBox(height: 24),
              _buildAutomaticCalculation(a),
              
              if (a.customerDues != null && a.customerDues!.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Customer Dues:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: subColor)),
                const SizedBox(height: 6),
                ...a.customerDues!.map((due) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(due.customer, style: TextStyle(fontSize: 11, color: subColor, fontWeight: FontWeight.w500)),
                      Text(due.dueAmount.toCurrency, style: TextStyle(fontSize: 11, color: subColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.tileControllers[a.id]?.collapse(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancel', style: TextStyle(color: subColor, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: hasFormErrors ? null : () => controller.setStep(a.id, 'confirming'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: eodPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Review & Submit →',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildConfirmStepView(Allocation a) {
    final subColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
    final soldText = controller.soldQtyControllers[a.id]?.text ?? '0';
    final sold = int.tryParse(soldText) ?? 0;
    final returned = controller.getToReturn(a);
    final cashText = controller.collectedAmountControllers[a.id]?.text ?? '0.00';
    final cash = double.tryParse(cashText) ?? 0.0;

    final expectedFullCash = sold * a.salePrice;
    final shortfall = expectedFullCash - cash;
    final hasShortfall = shortfall > 0.01;

    final isSubmitting = controller.isSubmittingMap[a.id] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please confirm before submitting:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryBox(
                '$sold pcs',
                'Cylinders Sold',
                const Color(0xFFE8F5E9),
                eodSuccess,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryBox(
                '$returned pcs',
                'Return to Warehouse',
                const Color(0xFFFFF8E1),
                eodWarning,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryBox(
                cash.toCurrency,
                'Cash to Hand In',
                const Color(0xFFE0F2F1),
                eodPrimary,
              ),
            ),
          ],
        ),
        if (hasShortfall) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE5C4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: eodWarning, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cash (${cash.toCurrency}) is less than expected (${expectedFullCash.toCurrency}). The difference of ${shortfall.toCurrency} will remain as customer dues.',
                    style: TextStyle(
                        color: eodWarning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (controller.stats.value != null && controller.stats.value!.pendingDueCollections > 0) ...[
          const SizedBox(height: 12),
          Text(
            '${controller.stats.value!.pendingDueCollections.toCurrency} in pending due collections will also be submitted with this EOD.',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: subColor),
          ),
        ],
        if (controller.stats.value != null && controller.stats.value!.totalOutstandingDues > 0) ...[
          const SizedBox(height: 6),
          Text(
            'Your total outstanding from your customers: ${controller.stats.value!.totalOutstandingDues.toCurrency}. Collect over time — this is only your sales.',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: subColor),
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          '⚠ This action cannot be undone by you. Only admin can edit after submission.',
          style: TextStyle(color: eodDanger, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: isSubmitting ? null : () => controller.setStep(a.id, 'form'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('← Back', style: TextStyle(color: subColor, fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : () => controller.submitReconciliation(a),
                style: ElevatedButton.styleFrom(
                  backgroundColor: eodPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Confirm & Submit', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryBox(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: value.length > 8 ? 12 : 16,
                  fontWeight: FontWeight.w900,
                  color: textColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w700, color: textColor),
              textAlign: TextAlign.center),
        ],
      ),
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
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color ?? defaultColor)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: labelColor)),
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
                controller.updateTrigger.value;
                final sold = controller.soldQtyControllers[a.id]?.text ?? '0';
                return _buildCalcBox(sold, 'Sold ✓', color: const Color(0xFFE8F5E9), textColor: eodSuccess);
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() {
                controller.updateTrigger.value;
                final toReturn = controller.getToReturn(a);
                return _buildCalcBox(toReturn.toString(), 'Return to warehouse', color: const Color(0xFFFFF8E1), textColor: eodWarning);
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() {
                controller.updateTrigger.value;
                final soldText = controller.soldQtyControllers[a.id]?.text ?? '0';
                final sold = int.tryParse(soldText) ?? 0;
                final toReturn = controller.getToReturn(a);
                final total = sold + toReturn;
                final exceeded = sold > a.qty;
                return _buildCalcBox(
                  exceeded ? '⚠' : total.toString(),
                  exceeded ? 'Exceeds limit!' : '$sold + $toReturn = $total',
                  color: exceeded ? const Color(0xFFFFEBEE) : const Color(0xFFE0F2F1),
                  textColor: exceeded ? eodDanger : eodPrimary,
                  showIcon: !exceeded,
                );
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
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showIcon) ...[
                Icon(Icons.check, size: 16, color: textColor),
                const SizedBox(width: 4),
              ],
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textColor)),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: textColor), textAlign: TextAlign.center),
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
          Text('No allocations for today.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: titleColor)),
          Text('Nothing to reconcile.', style: TextStyle(color: subColor)),
        ],
      ),
    );
  }

  Widget _buildAllDoneScreen() {
    final stats = controller.stats.value;
    final totalSold = controller.allocations.fold(0, (sum, a) => sum + (a.isReconciled || controller.reconciledIds.contains(a.id) ? a.soldQty : 0));
    final totalReturned = controller.allocations.fold(0, (sum, a) => sum + (a.isReconciled || controller.reconciledIds.contains(a.id) ? a.returnedQty : 0));

    final titleColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    final subColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
    final cardColor = Get.isDarkMode ? AppColors.surfaceDark : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.greenBgLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: AppColors.greenInk, size: 36),
                ),
                const SizedBox(height: 16),
                Text('All Done!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: titleColor)),
                const SizedBox(height: 4),
                Text('All allocations reconciled for today.', style: TextStyle(color: subColor, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                _buildAllDoneRow('Total Sold', '$totalSold pcs', titleColor),
                _buildAllDoneRow('Total Returned', '$totalReturned pcs', titleColor),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'CASH SUMMARY',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: subColor, letterSpacing: 0.5),
                  ),
                ),
                const SizedBox(height: 12),
                _buildAllDoneRow('Cylinder sales collected', (stats?.cashCollected ?? 0.0).toCurrency, titleColor),
                if (stats != null && stats.todayDueAmount > 0)
                  _buildAllDoneRow('Today\'s dues (collect later)', stats.todayDueAmount.toCurrency, titleColor, textColor: AppColors.orangeInk),
                const Divider(height: 24),
                _buildAllDoneRow('Total to hand in', (stats?.totalCashToHandIn ?? 0.0).toCurrency, titleColor, isBold: true),
                if (stats != null && stats.totalOutstandingDues > 0) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFE74C3C), size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Your outstanding (your customers only)',
                              style: TextStyle(color: Color(0xFFC0392B), fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                        Text(stats.totalOutstandingDues.toCurrency, style: const TextStyle(color: Color(0xFFC0392B), fontSize: 12, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: eodPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Back to Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDoneRow(String label, String value, Color labelColor, {Color? textColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isBold ? 14 : 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: labelColor)),
          Text(value, style: TextStyle(fontSize: isBold ? 16 : 14, fontWeight: isBold ? FontWeight.w900 : FontWeight.w700, color: textColor ?? labelColor)),
        ],
      ),
    );
  }
}
