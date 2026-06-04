import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/login_controller.dart';
import '../repository/login_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = LoginRepository(apiClient: apiClient);
    
    Get.lazyPut<LoginController>(() => LoginController(repository: repository));
  }
}
