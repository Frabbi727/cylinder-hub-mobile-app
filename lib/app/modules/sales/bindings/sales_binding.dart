import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/sales_controller.dart';
import '../repository/sales_repository.dart';

class SalesBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = SalesRepository(apiClient: apiClient);
    
    Get.lazyPut<SalesController>(() => SalesController(repository: repository));
  }
}
