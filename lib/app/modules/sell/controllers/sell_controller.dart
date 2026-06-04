import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../repository/sell_repository.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/cylinder_model.dart';

class SellController extends BaseController {
  final SellRepository repository;
  
  final customers = <Customer>[].obs;
  final cylinders = <Cylinder>[].obs;
  
  final selectedCustomer = Rxn<Customer>();
  final selectedCylinders = <Map<String, dynamic>>[].obs; // {cylinderId, qty, price}
  
  final paymentType = 'cash'.obs; // cash, partial, due
  final paidAmountController = TextEditingController();
  final notesController = TextEditingController();

  SellController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    showLoading();
    try {
      final custResp = await repository.getCustomers();
      final cylResp = await repository.getCylinders();
      
      if (custResp.success && custResp.data != null) {
        customers.assignAll(custResp.data!);
      }
      
      if (cylResp.success && cylResp.data != null) {
        cylinders.assignAll(cylResp.data!);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  void addCylinderItem(Cylinder cylinder) {
    selectedCylinders.add({
      'cylinder_id': cylinder.id,
      'qty': 1,
      'unit_price': 2400.0, // Should be from allocation in real logic
      'name': cylinder.name,
      'size': cylinder.size,
    });
  }

  void removeCylinderItem(int index) {
    selectedCylinders.removeAt(index);
  }

  Future<void> recordSale() async {
    showLoading();
    try {
      final response = await repository.createSale(
        customerId: selectedCustomer.value?.id,
        saleDate: DateTime.now().toString().split(' ').first,
        paymentType: paymentType.value,
        paidAmount: double.tryParse(paidAmountController.text),
        notes: notesController.text,
        items: selectedCylinders.map((item) => {
          'cylinder_id': item['cylinder_id'],
          'qty': item['qty'],
          'unit_price': item['unit_price'],
        }).toList(),
      );

      if (response.success) {
        Get.back(); // Or navigate to success screen
        Get.snackbar('Success', 'Sale recorded successfully');
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  @override
  void onClose() {
    paidAmountController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
