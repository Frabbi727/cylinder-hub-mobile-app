import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../repository/profile_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends BaseController {
  final ProfileRepository repository;
  final _authService = Get.find<AuthService>();
  
  final version = "".obs;
  final buildNumber = "".obs;
  
  // Directly observe the cached user from AuthService
  User? get user => _authService.user.value;

  ProfileController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _getPackageInfo();
    fetchProfile();
  }

  void _getPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      version.value = "1.0.0";
      buildNumber.value = "1";
    }
  }

  Future<void> fetchProfile() async {
    showLoading();
    try {
      final response = await repository.getProfile();
      if (response.success && response.data != null) {
        // Sync fresh data back to cache
        _authService.updateUser(response.data!);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  Future<void> logout() async {
    showLoading();
    try {
      await repository.logout();
      await _authService.clearSession();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }
}
