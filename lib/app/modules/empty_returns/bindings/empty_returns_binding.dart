import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../repository/empty_returns_repository.dart';
import '../controllers/empty_returns_controller.dart';

class EmptyReturnsBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = EmptyReturnsRepository(apiClient: apiClient);
    Get.lazyPut<EmptyReturnsController>(() => EmptyReturnsController(repository: repository));
  }
}
