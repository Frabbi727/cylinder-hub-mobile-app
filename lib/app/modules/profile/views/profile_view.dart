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
    final isDark = Get.isDarkMode;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationKeys.profile.tr),
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
                    child: Icon(Icons.person, size: 60, color: AppColors.textWhite),
                  ),
                  const SizedBox(height: AppSizes.p16),
                  Text(
                    'Karim Uddin',
                    style: textTheme.titleLarge,
                  ),
                  Text(
                    'karim@cylinderhub.com',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p32),
            
            // Language Section
            Text(
              TranslationKeys.language.tr.toUpperCase(),
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            Container(
              padding: const EdgeInsets.all(AppSizes.p8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                borderRadius: BorderRadius.circular(AppSizes.p16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildLangToggleBtn('English', 'en')),
                  Expanded(child: _buildLangToggleBtn('বাংলা', 'bn')),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.p24),
            
            // Theme Section
            Text(
              TranslationKeys.theme.tr.toUpperCase(),
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                borderRadius: BorderRadius.circular(AppSizes.p16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: ListTile(
                leading: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
                title: Text(
                  isDark ? TranslationKeys.darkMode.tr : TranslationKeys.lightMode.tr,
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) => controller.toggleTheme(),
                  activeColor: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.p24),
            
            // Logout Button
            InkWell(
              onTap: controller.logout,
              borderRadius: BorderRadius.circular(AppSizes.p16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.p16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.p16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppColors.error, size: AppSizes.i20),
                    const SizedBox(width: AppSizes.p8),
                    Text(
                      TranslationKeys.logout.tr,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.f16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.p40),
            
            // Version Info
            Center(
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(AppSizes.p20),
                ),
                child: Text(
                  'CylinderHub Salesman · v${controller.version.value} (${controller.buildNumber.value})',
                  style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
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
      final isDark = Get.isDarkMode;

      return GestureDetector(
        onTap: () {
          if (!isSelected) controller.toggleLanguage();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
          decoration: BoxDecoration(
            color: isSelected 
                ? (isDark ? AppColors.darkBorder : Colors.white) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.p12),
            boxShadow: isSelected && !isDark
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
            border: isSelected ? Border.all(color: isDark ? AppColors.primary : AppColors.lightBorder) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: AppSizes.f14,
              ),
            ),
          ),
        ),
      );
    });
  }
}
