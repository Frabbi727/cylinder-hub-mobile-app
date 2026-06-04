import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/my_day_controller.dart';
import '../repository/my_day_repository.dart';

class MyDayBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = MyDayRepository(apiClient: apiClient);
    
    Get.lazyPut<MyDayController>(() => MyDayController(repository: repository));
  }
}
