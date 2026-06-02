import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_sizes.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Language Switcher
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLangBtn('EN', 'en'),
                        _buildLangBtn('বাং', 'bn'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Logo
                Container(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.local_fire_department, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 16),
                const Text(
                  'CylinderHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  TranslationKeys.appSubtitle.tr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                // Login Card
                Container(
                  padding: const EdgeInsets.all(AppSizes.p24),
                  decoration: BoxDecoration(
                    color: AppColors.loginCardBg,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TranslationKeys.login.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        TranslationKeys.email.tr,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.emailController,
                        hint: 'karim@cylinderhub.com',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        TranslationKeys.password.tr,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => _buildTextField(
                        controller: controller.passwordController,
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: !controller.isPasswordVisible.value,
                        onToggleVisibility: controller.togglePasswordVisibility,
                      )),
                      const SizedBox(height: 32),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TranslationKeys.login.tr,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_outlined, color: Colors.white.withOpacity(0.5), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        TranslationKeys.roleRestriction.tr,
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangBtn(String label, String langCode) {
    return Obx(() {
      final isSelected = controller.currentLanguage.value == langCode;
      
      return GestureDetector(
        onTap: () {
          if (!isSelected) {
            controller.toggleLanguage();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
