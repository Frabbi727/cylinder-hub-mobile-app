import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/home_controller.dart';
import '../repository/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<HomeController>(() => HomeController(repository: Get.find<HomeRepository>()));
  }
}
