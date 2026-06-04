import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/sell_controller.dart';
import '../repository/sell_repository.dart';

class SellBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = SellRepository(apiClient: apiClient);
    
    Get.lazyPut<SellController>(() => SellController(repository: repository));
  }
}
