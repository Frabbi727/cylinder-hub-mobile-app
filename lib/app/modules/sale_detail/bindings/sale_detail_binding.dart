import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../../sales/repository/sales_repository.dart';
import '../controllers/sale_detail_controller.dart';

class SaleDetailBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = SalesRepository(apiClient: apiClient);
    Get.lazyPut<SaleDetailController>(() => SaleDetailController(repository: repository));
  }
}
