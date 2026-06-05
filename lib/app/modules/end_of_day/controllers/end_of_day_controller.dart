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

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm End of Day'),
        content: Text(
          'Submit: Sold $soldQty pcs, Collected ${collected.toCurrency} for ${allocation.cylinder?.name ?? "allocation"}?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Get.back(result: true), child: const Text('Submit')),
        ],
      ),
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

  @override
  void onClose() {
    for (final c in soldQtyControllers.values) { c.dispose(); }
    for (final c in collectedAmountControllers.values) { c.dispose(); }
    super.onClose();
  }
}
