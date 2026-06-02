import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends BaseController {
  final _storage = GetStorage();
  
  final version = "".obs;
  final buildNumber = "".obs;

  @override
  void onInit() {
    super.onInit();
    _getPackageInfo();
  }

  void _getPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      print("ProfileController: Error fetching package info: $e");
      // Fallback values if plugin fails or is not ready
      version.value = "1.0.0";
      buildNumber.value = "1";
    }
  }

  void logout() {
    _storage.write('isLoggedIn', false);
    Get.offAllNamed(Routes.LOGIN);
  }
}
