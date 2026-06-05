import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/return_model.dart';
import '../../../data/models/sale_model.dart';
import '../repository/customer_repository.dart';

class CustomerDetailController extends BaseController {
  final CustomerRepository repository;

  final customer = Rxn<Customer>();
  final sales = <Sale>[].obs;
  final empties = <CylinderReturn>[].obs;
  final selectedTab = 0.obs;

  CustomerDetailController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    final customerId = Get.arguments as int?;
    if (customerId != null) fetchAll(customerId);
  }

  Future<void> fetchAll(int customerId) async {
    showLoading();
    try {
      final results = await Future.wait([
        repository.getCustomerDetail(customerId),
        repository.getCustomerSales(customerId),
        repository.getCustomerEmpties(customerId),
      ]);

      final customerResp = results[0] as dynamic;
      final salesResp = results[1] as dynamic;
      final emptiesResp = results[2] as dynamic;

      if (customerResp.success && customerResp.data != null) {
        customer.value = customerResp.data;
      }
      if (salesResp.success && salesResp.data != null) {
        sales.assignAll(salesResp.data);
      }
      if (emptiesResp.success && emptiesResp.data != null) {
        empties.assignAll(emptiesResp.data);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }
}
