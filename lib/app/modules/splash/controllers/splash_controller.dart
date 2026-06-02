import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("SplashController: onInit called");
    _startApp();
  }

  void _startApp() async {
    print("SplashController: _startApp started");
    await Future.delayed(const Duration(seconds: 3));
    print("SplashController: Delay finished");
    
    try {
      final storage = GetStorage();
      bool isFirstTime = storage.read('isFirstTime') ?? true;
      bool isLoggedIn = storage.read('isLoggedIn') ?? false;

      print("SplashController: isFirstTime=$isFirstTime, isLoggedIn=$isLoggedIn");

      if (isFirstTime) {
        Get.offAllNamed(Routes.ONBOARDING);
      } else if (isLoggedIn) {
        Get.offAllNamed(Routes.MAIN_NAVIGATION);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
      print("SplashController: Navigation command sent");
    } catch (e) {
      print("SplashController: Error: $e");
    }
  }
}
