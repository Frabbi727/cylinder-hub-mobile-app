import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/my_reports_controller.dart';
import '../repository/my_reports_repository.dart';

class MyReportsBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = MyReportsRepository(apiClient: apiClient);
    
    Get.lazyPut<MyReportsController>(() => MyReportsController(repository: repository));
  }
}
