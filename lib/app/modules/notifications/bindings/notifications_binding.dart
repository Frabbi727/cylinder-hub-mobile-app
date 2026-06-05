import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../repository/notifications_repository.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = NotificationsRepository(apiClient: apiClient);
    Get.lazyPut<NotificationsController>(() => NotificationsController(repository: repository));
  }
}
