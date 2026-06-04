import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/profile_controller.dart';
import '../repository/profile_repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final repository = ProfileRepository(apiClient: apiClient);
    
    Get.lazyPut<ProfileController>(() => ProfileController(repository: repository));
  }
}
