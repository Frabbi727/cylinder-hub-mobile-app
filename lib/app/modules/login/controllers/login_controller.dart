import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../repository/login_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends BaseController {
  final LoginRepository repository;
  final _authService = Get.find<AuthService>();

  final emailController = TextEditingController(text: 'karim@cylinderhub.com');
  final passwordController = TextEditingController(text: '12345678');
  
  final isPasswordVisible = false.obs;

  LoginController({required this.repository});

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      handleError('Please enter email and password');
      return;
    }

    showLoading();
    try {
      final response = await repository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.success && response.data != null) {
        // Use AuthService to save session and cache user info
        await _authService.saveSession(response.data!);
        
        Get.offAllNamed(Routes.MAIN_NAVIGATION);
      } else {
        handleError(response.message ?? 'Login failed');
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
