import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/models/sale_model.dart';
import '../../sales/repository/sales_repository.dart';
import '../../my_day/controllers/my_day_controller.dart';
import '../../dues/controllers/dues_controller.dart';
import '../../sales/controllers/sales_controller.dart';

class SaleDetailController extends BaseController {
  final SalesRepository repository;

  final sale = Rxn<Sale>();
  final isCollecting = false.obs;

  final amountController = TextEditingController();
  final notesController = TextEditingController();
  late String collectionDate;

  SaleDetailController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    collectionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final saleId = Get.arguments as int?;
    if (saleId != null) fetchSaleDetail(saleId);
  }

  Future<void> fetchSaleDetail(int saleId) async {
    showLoading();
    try {
      final response = await repository.getSaleDetail(saleId);
      if (response.success && response.data != null) {
        sale.value = response.data!.sale;
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  Future<void> collectPayment() async {
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      handleError('Enter a valid amount');
      return;
    }
    isCollecting.value = true;
    try {
      final response = await repository.collectPayment(
        sale.value!.id,
        amount,
        collectionDate,
        notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      );
      if (response.success && response.data != null) {
        sale.value = response.data;
        amountController.clear();
        notesController.clear();
        if (Get.isRegistered<MyDayController>()) Get.find<MyDayController>().refresh();
        if (Get.isRegistered<DuesController>()) Get.find<DuesController>().refresh();
        if (Get.isRegistered<SalesController>()) Get.find<SalesController>().refresh();
        Get.back();
        Get.snackbar('Success', 'Payment collected successfully',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      isCollecting.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
