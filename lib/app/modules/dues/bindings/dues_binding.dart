import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/dues_controller.dart';
import '../repository/dues_repository.dart';

class DuesBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = DuesRepository(apiClient: apiClient);
    
    Get.lazyPut<DuesController>(() => DuesController(repository: repository));
  }
}
