import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../repository/customer_repository.dart';
import '../controllers/customer_list_controller.dart';
import '../controllers/customer_detail_controller.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = CustomerRepository(apiClient: apiClient);
    Get.lazyPut<CustomerListController>(() => CustomerListController(repository: repository));
    Get.lazyPut<CustomerDetailController>(() => CustomerDetailController(repository: repository));
  }
}
