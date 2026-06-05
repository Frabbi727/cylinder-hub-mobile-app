import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/allocation_model.dart';
import '../../my_day/repository/my_day_repository.dart';
import '../../my_day/controllers/my_day_controller.dart';

class EndOfDayController extends BaseController {
  final MyDayRepository repository;
  final _authService = Get.find<AuthService>();

  final allocations = <Allocation>[].obs;
  final reconciledIds = <int>{}.obs;

  final Map<int, TextEditingController> soldQtyControllers = {};
  final Map<int, TextEditingController> collectedAmountControllers = {};

  EndOfDayController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _loadAllocations();
  }

  void _loadAllocations() {
    final userAllocations = _authService.user.value?.allocations ?? [];
    allocations.assignAll(userAllocations.where((a) => !a.isReconciled).toList());

    for (final a in allocations) {
      soldQtyControllers[a.id] = TextEditingController(text: a.soldQty.toString());
      collectedAmountControllers[a.id] = TextEditingController(
        text: a.collectedAmount.toStringAsFixed(0),
      );
    }

    final reconciled = userAllocations.where((a) => a.isReconciled).map((a) => a.id);
    reconciledIds.addAll(reconciled);
  }

  double get totalExpectedCash {
    return allocations.fold(0.0, (sum, a) {
      final amount = double.tryParse(collectedAmountControllers[a.id]?.text ?? '0') ?? 0;
      return sum + amount;
    });
  }

  Future<void> reconcile(Allocation allocation) async {
    final soldQty = int.tryParse(soldQtyControllers[allocation.id]?.text ?? '0') ?? 0;
    final collected = double.tryParse(collectedAmountControllers[allocation.id]?.text ?? '0') ?? 0.0;

    if (soldQty < 0 || collected < 0) {
      handleError('Values cannot be negative');
      return;
    }

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm End of Day'),
        content: Text(
          'Submit: Sold $soldQty pcs, Collected ৳${collected.toStringAsFixed(0)} for ${allocation.cylinder?.name ?? 'allocation'}?',
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
        allocations.removeWhere((a) => a.id == allocation.id);
        if (Get.isRegistered<MyDayController>()) Get.find<MyDayController>().refresh();
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
