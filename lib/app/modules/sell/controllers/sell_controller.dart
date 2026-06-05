import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../repository/sell_repository.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/cylinder_model.dart';
import '../../my_day/controllers/my_day_controller.dart';
import '../../sales/controllers/sales_controller.dart';
import '../../dues/controllers/dues_controller.dart';

import '../../main_navigation/controllers/main_navigation_controller.dart';

class SellController extends BaseController {
  final SellRepository repository;
  final _authService = Get.find<AuthService>();

  final customers = <Customer>[].obs;
  final cylinders = <Cylinder>[].obs;

  final selectedCustomer = Rxn<Customer>();
  final selectedCylinders = <Map<String, dynamic>>[].obs;
  final qtyControllers = <TextEditingController>[].obs;
  final priceControllers = <TextEditingController>[].obs;

  final paymentType = 'cash'.obs;
  final paidAmountController = TextEditingController();
  final notesController = TextEditingController();

  SellController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  @override
  Future<void> refresh() async {
    resetForm();
    await fetchInitialData();
  }

  void resetForm() {
    selectedCylinders.clear();
    for (var controller in qtyControllers) {
      controller.dispose();
    }
    qtyControllers.clear();
    for (var controller in priceControllers) {
      controller.dispose();
    }
    priceControllers.clear();
    selectedCustomer.value = null;
    paymentType.value = 'cash';
    paidAmountController.clear();
    notesController.clear();
  }

  Future<void> fetchInitialData() async {
    showLoading();
    try {
      final results = await Future.wait([
        repository.getCustomers(),
        repository.getCylinders(),
      ]);
      final custResp = results[0] as dynamic;
      final cylResp = results[1] as dynamic;
      if (custResp.success && custResp.data != null) customers.assignAll(custResp.data);
      if (cylResp.success && cylResp.data != null) cylinders.assignAll(cylResp.data);
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  double _priceForCylinder(int cylinderId) {
    final allocations = _authService.user.value?.allocations;
    if (allocations != null) {
      final match = allocations.firstWhereOrNull((a) => a.cylinderId == cylinderId);
      if (match != null) return match.salePrice;
    }
    return 0.0;
  }

  void addCylinderItem(Cylinder cylinder) {
    final alreadyAdded = selectedCylinders.any((item) => item['cylinder_id'] == cylinder.id);
    if (alreadyAdded) return;

    final stock = cylinder.stock?.filledQty ?? 0;
    if (stock <= 0) {
      handleError('Out of stock: ${cylinder.name}');
      return;
    }

    final unitPrice = _priceForCylinder(cylinder.id);
    selectedCylinders.add({
      'cylinder_id': cylinder.id,
      'qty': 1,
      'unit_price': unitPrice,
      'name': cylinder.name,
      'size': '${cylinder.size}kg',
      'stock': stock,
    });
    qtyControllers.add(TextEditingController(text: '1'));
    priceControllers.add(TextEditingController(text: unitPrice.toStringAsFixed(0)));
  }

  void removeCylinderItem(int index) {
    selectedCylinders.removeAt(index);
    qtyControllers[index].dispose();
    qtyControllers.removeAt(index);
    priceControllers[index].dispose();
    priceControllers.removeAt(index);
  }

  void updateQty(int index, int qty) {
    final maxStock = selectedCylinders[index]['stock'] as int;

    if (qty > maxStock) {
      handleError('Max stock available: $maxStock');
      qty = maxStock;
    }
    if (qty < 1) qty = 1;

    final item = Map<String, dynamic>.from(selectedCylinders[index]);
    item['qty'] = qty;
    selectedCylinders[index] = item;

    if (qtyControllers[index].text != qty.toString()) {
      qtyControllers[index].text = qty.toString();
    }
  }

  void updatePrice(int index, double price) {
    final item = Map<String, dynamic>.from(selectedCylinders[index]);
    item['unit_price'] = price;
    selectedCylinders[index] = item;
  }

  double get totalAmount => selectedCylinders.fold(0.0, (sum, item) {
    return sum + ((item['qty'] as int) * (item['unit_price'] as double));
  });

  Future<void> recordSale() async {
    if (selectedCylinders.isEmpty) {
      handleError('Please add at least one cylinder');
      return;
    }
    if (paymentType.value == 'partial') {
      final paid = double.tryParse(paidAmountController.text.trim()) ?? 0;
      if (paid <= 0 || paid >= totalAmount) {
        handleError('Partial amount must be between 0 and total');
        return;
      }
    }

    showLoading();
    try {
      final response = await repository.createSale(
        customerId: selectedCustomer.value?.id,
        saleDate: DateTime.now().toString().split(' ').first,
        paymentType: paymentType.value,
        paidAmount: paymentType.value == 'partial'
            ? double.tryParse(paidAmountController.text.trim())
            : null,
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
        items: selectedCylinders
            .map((item) => {
                  'cylinder_id': item['cylinder_id'],
                  'qty': item['qty'],
                  'unit_price': item['unit_price'],
                })
            .toList(),
      );

      if (response.success && response.data != null) {
        resetForm();
        Get.snackbar('Success', 'Sale recorded successfully', snackPosition: SnackPosition.BOTTOM);
        if (Get.isRegistered<MyDayController>()) Get.find<MyDayController>().refresh();
        if (Get.isRegistered<SalesController>()) Get.find<SalesController>().refresh();
        if (Get.isRegistered<DuesController>()) Get.find<DuesController>().refresh();

        // Navigate to Sales History tab
        if (Get.isRegistered<MainNavigationController>()) {
          Get.find<MainNavigationController>().changeIndex(1);
        }
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  @override
  void onClose() {
    for (var controller in qtyControllers) {
      controller.dispose();
    }
    for (var controller in priceControllers) {
      controller.dispose();
    }
    paidAmountController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
