import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../repository/sales_repository.dart';
import '../../../data/models/sale_model.dart';

class SalesController extends BaseController {
  final SalesRepository repository;
  final sales = <Sale>[].obs;
  
  final selectedPeriod = 'Today'.obs; // Today, Week, Month, Custom

  SalesController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  Future<void> fetchSales() async {
    showLoading();
    try {
      final response = await repository.getSales(
        today: selectedPeriod.value == 'Today',
        // Add more logic for other periods
      );
      if (response.success && response.data != null) {
        sales.assignAll(response.data!);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    fetchSales();
  }
}
