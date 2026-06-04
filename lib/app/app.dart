import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/app_theme.dart';
import 'core/values/app_colors.dart';
import 'core/values/app_env.dart';
import 'core/values/languages/translation_keys.dart';
import 'core/values/languages/translations.dart';
import 'routes/app_pages.dart';

class CylinderHubApp extends StatelessWidget {
  const CylinderHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    
    // Determine initial settings
    ThemeMode themeMode = storage.read('isDarkMode') == true ? ThemeMode.dark : ThemeMode.light;
    Locale locale = storage.read('isBangla') == true ? const Locale('bn', 'BD') : const Locale('en', 'US');

    return GetMaterialApp(
      title: AppConfig.instance.appTitle,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Translations
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),

      builder: (context, child) {
        final connectivityService = Get.find<ConnectivityService>();
        
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          child: Stack(
            children: [
              // Main App Content with SafeArea for top (status bar)
              SafeArea(
                top: false, 
                bottom: false, 
                child: child!,
              ),
              
              // Bottom Warning Banner
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Obx(() => connectivityService.isConnected.value
                    ? const SizedBox.shrink()
                    : Material(
                        color: AppColors.error,
                        child: SafeArea(
                          top: false,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  TranslationKeys.noInternet.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
              ),
            ],
          ),
        );
      },
    );
  }
}
