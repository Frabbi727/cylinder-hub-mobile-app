import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: AppColors.homeGradient,
        ),
        child: Stack(
          children: [
            // Language Toggle
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(3),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(99),
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
            
            // Login Form
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.local_fire_department, size: 38, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.02,
                        ),
                        children: [
                          const TextSpan(text: 'Cylinder'),
                          TextSpan(
                            text: 'Hub',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      TranslationKeys.appSubtitle.tr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TranslationKeys.login.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Email Field
                            Text(
                              TranslationKeys.email.tr,
                              style: Theme.of(context).inputDecorationTheme.labelStyle,
                            ),
                            const SizedBox(height: 7),
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person, size: 18),
                                hintText: TranslationKeys.email.tr,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Password Field
                            Text(
                              TranslationKeys.password.tr,
                              style: Theme.of(context).inputDecorationTheme.labelStyle,
                            ),
                            const SizedBox(height: 7),
                            Obx(() => TextFormField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock, size: 18),
                                hintText: TranslationKeys.password.tr,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value 
                                      ? Icons.visibility_off 
                                      : Icons.visibility,
                                    size: 18,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                            )),
                            const SizedBox(height: 22),
                            
                            // Login Button
                            Obx(() => ElevatedButton(
                              onPressed: controller.isLoading ? null : controller.login,
                              child: controller.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(TranslationKeys.signIn.tr),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward, size: 18),
                                      ],
                                    ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield, size: 14, color: Colors.white.withValues(alpha: 0.72)),
                        const SizedBox(width: 6),
                        Text(
                          TranslationKeys.roleRestriction.tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 13),
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.blueInk : Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      );
    });
  }
}
