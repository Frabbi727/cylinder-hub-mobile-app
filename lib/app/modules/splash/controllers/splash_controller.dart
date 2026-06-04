import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _startApp();
  }

  void _startApp() async {
    await Future.delayed(const Duration(seconds: 2));
    
    bool isFirstTime = _storage.read('isFirstTime') ?? true;

    if (isFirstTime) {
      Get.offAllNamed(Routes.ONBOARDING);
    } else if (_authService.isLoggedIn.value) {
      Get.offAllNamed(Routes.MAIN_NAVIGATION);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
