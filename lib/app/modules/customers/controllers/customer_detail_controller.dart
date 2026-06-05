import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/customer_response_models.dart';
import '../../../data/models/sale_model.dart';
import '../repository/customer_repository.dart';

class CustomerDetailController extends BaseController {
  final CustomerRepository repository;

  final customer = Rxn<Customer>();
  final sales = <Sale>[].obs;
  final empties = <CustomerEmptyBalance>[].obs;
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

      final customerResp = results[0] as ApiResponse<Customer>;
      final salesResp = results[1] as ApiResponse<List<Sale>>;
      final emptiesResp = results[2] as ApiResponse<CustomerEmptyResponse>;

      if (customerResp.success && customerResp.data != null) {
        customer.value = customerResp.data;
      }
      if (salesResp.success && salesResp.data != null) {
        sales.assignAll(salesResp.data!);
      }
      if (emptiesResp.success && emptiesResp.data != null) {
        empties.assignAll(emptiesResp.data!.balances);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }
}
