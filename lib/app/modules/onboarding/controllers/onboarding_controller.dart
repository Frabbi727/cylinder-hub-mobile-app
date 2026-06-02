import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends BaseController {
  final _storage = GetStorage();

  void completeOnboarding() {
    _storage.write('isFirstTime', false);
    Get.offAllNamed(Routes.LOGIN);
  }
}
