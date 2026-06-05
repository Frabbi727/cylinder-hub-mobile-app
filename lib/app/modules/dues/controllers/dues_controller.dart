import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../repository/dues_repository.dart';
import '../../../data/models/customer_model.dart';

class DuesController extends BaseController {
  final DuesRepository repository;
  final overdueCustomers = <OverdueCustomer>[].obs;

  DuesController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchOverdue();
  }

  double get totalDue => overdueCustomers.fold(0.0, (sum, c) => sum + c.totalDue);
  int get totalSalesCount => overdueCustomers.fold(0, (sum, c) => sum + c.unpaidSalesCount);

  Future<void> fetchOverdue() async {
    showLoading();
    try {
      final response = await repository.getOverdueCustomers();
      if (response.success && response.data != null) {
        overdueCustomers.assignAll(response.data!);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }
}
