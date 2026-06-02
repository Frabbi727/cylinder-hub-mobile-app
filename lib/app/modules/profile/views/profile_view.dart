import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_sizes.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(TranslationKeys.profile.tr),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Karim Uddin',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'karim@cylinderhub.com',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Language Section
            Text(
              TranslationKeys.language.tr.toUpperCase(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(AppSizes.p8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildLangToggleBtn('English', 'en')),
                  Expanded(child: _buildLangToggleBtn('বাংলা', 'bn')),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Theme Section
            Text(
              TranslationKeys.theme.tr.toUpperCase(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(AppSizes.p8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: Icon(
                  Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
                title: Text(
                  Get.isDarkMode ? TranslationKeys.darkMode.tr : TranslationKeys.lightMode.tr,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Switch(
                  value: Get.isDarkMode,
                  onChanged: (value) => controller.toggleTheme(),
                  activeColor: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            // Logout Button
            InkWell(
              onTap: controller.logout,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE), // Light red background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Color(0xFFD32F2F), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      TranslationKeys.logout.tr,
                      style: const TextStyle(
                        color: Color(0xFFD32F2F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Version Info
            Center(
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'CylinderHub Salesman · v${controller.version.value} (${controller.buildNumber.value})',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangToggleBtn(String label, String langCode) {
    return Obx(() {
      final isSelected = controller.currentLanguage.value == langCode;
      return GestureDetector(
        onTap: () {
          if (!isSelected) controller.toggleLanguage();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected 
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
            border: isSelected ? Border.all(color: Colors.grey.shade200) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ),
      );
    });
  }
}
