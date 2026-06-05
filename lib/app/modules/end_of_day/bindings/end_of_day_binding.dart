import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../../my_day/repository/my_day_repository.dart';
import '../controllers/end_of_day_controller.dart';

class EndOfDayBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = MyDayRepository(apiClient: apiClient);
    Get.lazyPut<EndOfDayController>(() => EndOfDayController(repository: repository));
  }
}
