import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class LoginController extends BaseController {
  final _storage = GetStorage();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    // Simulate login
    showLoading();
    Future.delayed(const Duration(seconds: 1), () {
      hideLoading();
      _storage.write('isLoggedIn', true);
      Get.offAllNamed(Routes.MAIN_NAVIGATION);
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
