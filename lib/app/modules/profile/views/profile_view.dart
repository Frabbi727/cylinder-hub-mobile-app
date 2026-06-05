import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/profile_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: TranslationKeys.profile.tr,
            accent: AppColors.reportsGradient,
            curve: true,
            onBack: () => Get.find<MainNavigationController>().changeIndex(0),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        Obx(() {
                          final name = controller.user?.name ?? '';
                          final initials = name.trim().split(' ')
                              .where((w) => w.isNotEmpty)
                              .take(2)
                              .map((w) => w[0].toUpperCase())
                              .join();
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              gradient: AppColors.reportsGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                initials.isEmpty ? '?' : initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        Obx(() => Text(
                          controller.user?.name ?? '...',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        Obx(() => Text(
                          controller.user?.email ?? '...',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.text2Color,
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Language Selection
                  _buildSectionHeader(context, TranslationKeys.language.tr),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: context.line2Color,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildLangToggleBtn(context, 'English', 'en')),
                        Expanded(child: _buildLangToggleBtn(context, 'বাংলা', 'bn')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Theme Selection
                  _buildSectionHeader(context, TranslationKeys.theme.tr),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: AppColors.blue,
                      ),
                      title: Text(
                        isDark ? TranslationKeys.darkMode.tr : TranslationKeys.lightMode.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => controller.toggleTheme(),
                        activeTrackColor: AppColors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logout
                  InkWell(
                    onTap: () async {
                      final ok = await Get.dialog<bool>(AlertDialog(
                        title: const Text('Log Out'),
                        content: const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 44),
                            ),
                            child: const Text('Log Out'),
                          ),
                        ],
                      ));
                      if (ok == true) controller.logout();
                    },
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: AppColors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            TranslationKeys.logout.tr,
                            style: const TextStyle(
                              color: AppColors.red,
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
                        color: context.lineColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'CylinderHub Salesman · v${controller.version.value} (${controller.buildNumber.value})',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.text3Color),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: context.text3Color,
        letterSpacing: 0.05,
      ),
    );
  }

  Widget _buildLangToggleBtn(BuildContext context, String label, String langCode) {
    return Obx(() {
      final isSelected = controller.currentLanguage.value == langCode;

      return GestureDetector(
        onTap: () {
          if (!isSelected) controller.toggleLanguage();
        },
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? context.surfaceColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.blueInk : context.text2Color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      );
    });
  }
}
