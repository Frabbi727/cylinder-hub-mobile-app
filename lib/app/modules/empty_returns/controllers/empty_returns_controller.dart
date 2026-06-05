import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/date_ext.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/cylinder_model.dart';
import '../repository/empty_returns_repository.dart';
import '../../my_day/controllers/my_day_controller.dart';

class EmptyReturnsController extends BaseController {
  final EmptyReturnsRepository repository;

  final cylinders = <Cylinder>[].obs;
  final customers = <Customer>[].obs;
  final selectedCylinder = Rxn<Cylinder>();
  final selectedCustomer = Rxn<Customer>();
  final qty = 1.obs;
  final isExtra = false.obs;
  final returnDate = ''.obs;
  final extraReasonController = TextEditingController();
  final notesController = TextEditingController();

  EmptyReturnsController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    returnDate.value = DateTime.now().toApiDate;
    _loadData();
  }

  Future<void> _loadData() async {
    showLoading();
    try {
      final results = await Future.wait([
        repository.getCylinders(),
        repository.getCustomers(),
      ]);
      final cylResp = results[0] as dynamic;
      final custResp = results[1] as dynamic;
      if (cylResp.success && cylResp.data != null) cylinders.assignAll(cylResp.data);
      if (custResp.success && custResp.data != null) customers.assignAll(custResp.data);
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  void incrementQty() => qty.value++;
  void decrementQty() { if (qty.value > 1) qty.value--; }

  Future<void> submitReturn() async {
    if (selectedCylinder.value == null) {
      handleError('Please select a cylinder type');
      return;
    }
    if (isExtra.value && extraReasonController.text.trim().isEmpty) {
      handleError('Please enter a reason for extra return');
      return;
    }

    showLoading();
    try {
      final response = await repository.createReturn(
        cylinderId: selectedCylinder.value!.id,
        qty: qty.value,
        returnDate: returnDate.value,
        customerId: selectedCustomer.value?.id,
        type: 'normal',
        isExtra: isExtra.value,
        extraReason: extraReasonController.text.trim(),
        notes: notesController.text.trim(),
      );
      if (response.success) {
        if (Get.isRegistered<MyDayController>()) Get.find<MyDayController>().refresh();
        Get.back();
        Get.snackbar('Success', 'Empty cylinders returned successfully',
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
    extraReasonController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
