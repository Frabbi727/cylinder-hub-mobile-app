import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/allocation_model.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/models/sale_model.dart';
import '../../my_day/repository/my_day_repository.dart';
import '../../my_day/controllers/my_day_controller.dart';
import '../../../core/values/currency_ext.dart';
import '../../../core/values/app_colors.dart';

class EndOfDayController extends BaseController {
  final MyDayRepository repository;
  final _authService = Get.find<AuthService>();

  final allocations = <Allocation>[].obs;
  final reconciledIds = <int>{}.obs;
  final stats = Rxn<DashboardStats>();
  final pendingCollections = <DueCollection>[].obs;
  final totalFromAllocations = 0.0.obs;
  final updateTrigger = 0.obs; // Dummy trigger for Obx

  EndOfDayController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    final user = _authService.user.value;
    if (user == null) return;

    showLoading();
    try {
      final response = await repository.getDashboardData(user.id);
      if (response.success && response.data != null) {
        final data = response.data!;
        stats.value = data.stats;
        pendingCollections.assignAll(data.pendingCollections ?? []);
        
        final userAllocations = data.salesman?.allocations ?? [];
        allocations.assignAll(userAllocations);

        for (final a in allocations) {
          if (a.isReconciled) continue; // Skip controllers for already reconciled items

          soldQtyControllers[a.id]?.dispose();
          collectedAmountControllers[a.id]?.dispose();

          soldQtyControllers[a.id] = TextEditingController(text: a.soldQty.toString());
          final initialCash = a.cashCollectedActual ?? a.collectedAmount;
          collectedAmountControllers[a.id] = TextEditingController(
            text: initialCash.toStringAsFixed(2),
          );

          soldQtyControllers[a.id]!.addListener(() {
            updateTrigger.value++;
            _onSoldQtyChanged(a);
          });
          collectedAmountControllers[a.id]!.addListener(() {
            updateTrigger.value++;
            _updateTotalFromAllocations();
          });
        }

        final reconciled = userAllocations.where((a) => a.isReconciled).map((a) => a.id);
        reconciledIds.assignAll(reconciled);
        _updateTotalFromAllocations();
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  final Map<int, TextEditingController> soldQtyControllers = {};
  final Map<int, TextEditingController> collectedAmountControllers = {};

  void _onSoldQtyChanged(Allocation a) {
    final controller = soldQtyControllers[a.id];
    final cashController = collectedAmountControllers[a.id];
    if (controller == null || cashController == null) return;

    final newQty = int.tryParse(controller.text) ?? 0;
    
    if (a.soldQty > 0) {
      final originalCash = a.cashCollectedActual ?? a.collectedAmount;
      final newCash = (newQty / a.soldQty) * originalCash;
      cashController.text = newCash.toStringAsFixed(2);
    } else {
      final newCash = newQty * a.salePrice;
      cashController.text = newCash.toStringAsFixed(2);
    }
    _updateTotalFromAllocations();
  }

  void _updateTotalFromAllocations() {
    totalFromAllocations.value = allocations.fold(0.0, (sum, a) {
      if (a.isReconciled || reconciledIds.contains(a.id)) {
        return sum + a.collectedAmount;
      }
      final amount =
          double.tryParse(collectedAmountControllers[a.id]?.text ?? '0') ?? 0;
      return sum + amount;
    });
  }

  int getToReturn(Allocation a) {
    final sold = int.tryParse(soldQtyControllers[a.id]?.text ?? '0') ?? 0;
    return (a.qty - sold).clamp(0, a.qty);
  }

  double get totalExpectedCash {
    double fromPendingDues = pendingCollections.fold(0.0, (sum, c) => sum + c.amount);
    return totalFromAllocations.value + fromPendingDues;
  }

  Future<void> reconcile(Allocation allocation) async {
    final soldQty = int.tryParse(soldQtyControllers[allocation.id]?.text ?? '0') ?? 0;
    final collected = double.tryParse(collectedAmountControllers[allocation.id]?.text ?? '0') ?? 0.0;

    if (soldQty < 0 || collected < 0) {
      handleError('Values cannot be negative');
      return;
    }

    if (soldQty > allocation.qty) {
      handleError('Sold quantity cannot exceed allocated quantity (\${allocation.qty})');
      return;
    }

    final toReturn = getToReturn(allocation);
    final expectedFullCash = soldQty * allocation.salePrice;
    final shortfall = expectedFullCash - collected;
    final hasShortfall = shortfall > 0.01;

    final confirmed = await Get.dialog<bool>(
      _buildConfirmationDialog(allocation, soldQty, toReturn, collected,
          shortfall: hasShortfall ? shortfall : null),
      barrierDismissible: false,
    );
    if (confirmed != true) return;

    showLoading();
    try {
      final response = await repository.reconcileAllocation(allocation.id, soldQty, collected);
      if (response.success) {
        reconciledIds.add(allocation.id);
        
        if (Get.isRegistered<MyDayController>()) Get.find<MyDayController>().refresh();
        
        await refreshData();

        Get.snackbar('Done', 'Allocation reconciled successfully',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  Widget _buildConfirmationDialog(
    Allocation a,
    int sold,
    int returned,
    double cash, {
    double? shortfall,
  }) {
    final titleColor = Get.isDarkMode ? AppColors.text1Dark : AppColors.text1Light;
    final subColor = Get.isDarkMode ? AppColors.text3Dark : AppColors.text3Light;
    final cardColor = Get.isDarkMode ? AppColors.surfaceDark : Colors.white;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confirm Before Submitting',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900, color: titleColor)),
            const SizedBox(height: 8),
            Text(a.cylinder?.name ?? 'Allocation',
                style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryBox(
                    sold.toString(),
                    'Sold',
                    AppColors.greenBgLight,
                    AppColors.greenInk,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryBox(
                    returned.toString(),
                    'Return',
                    const Color(0xFFFFF4E5),
                    const Color(0xFFD35400),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryBox(
                    cash.toCurrency,
                    'Cash',
                    const Color(0xFFEEF2F6),
                    const Color(0xFF13696D),
                  ),
                ),
              ],
            ),
            if (shortfall != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFE5C4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFE67E22), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cash (${cash.toCurrency}) is less than expected (${(sold * a.salePrice).toCurrency}). The difference of ${shortfall.toCurrency} will remain as customer dues.',
                        style: const TextStyle(
                            color: Color(0xFF8A5A2E),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              '⚠ This action cannot be undone. Only admin can edit after submission.',
              style: TextStyle(
                  color: AppColors.redInk, fontSize: 11, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(result: false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(
                            color: subColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13696D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Confirm & Submit',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
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
                  fontSize: 10, fontWeight: FontWeight.w700, color: textColor)),
        ],
      ),
    );
  }

  @override
  void onClose() {
    for (final c in soldQtyControllers.values) { c.dispose(); }
    for (final c in collectedAmountControllers.values) { c.dispose(); }
    super.onClose();
  }
}
