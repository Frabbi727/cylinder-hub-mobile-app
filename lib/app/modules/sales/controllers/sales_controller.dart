import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/base/base_controller.dart';
import '../repository/sales_repository.dart';
import '../../../data/models/sale_model.dart';

class SalesController extends BaseController {
  final SalesRepository repository;
  final sales = <Sale>[].obs;
  final selectedPeriod = 'Today'.obs;

  SalesController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  Future<void> fetchSales() async {
    showLoading();
    try {
      final now = DateTime.now();
      final fmt = DateFormat('yyyy-MM-dd');

      bool? today;
      String? from;
      String? to;

      switch (selectedPeriod.value) {
        case 'Today':
          today = true;
          break;
        case 'Week':
          final monday = now.subtract(Duration(days: now.weekday - 1));
          from = fmt.format(monday);
          to = fmt.format(now);
          break;
        case 'Month':
          from = fmt.format(DateTime(now.year, now.month, 1));
          to = fmt.format(now);
          break;
      }

      final response = await repository.getSales(today: today, from: from, to: to);
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
