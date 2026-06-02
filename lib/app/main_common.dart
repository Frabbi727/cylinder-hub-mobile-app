import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/values/app_env.dart';
import 'core/values/languages/translations.dart';
import 'data/api/api_client.dart';
import 'routes/app_pages.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  final storage = GetStorage();
  
  // Inject global dependencies
  Get.put(ApiClient(), permanent: true);

  // Determine initial settings
  ThemeMode themeMode = storage.read('isDarkMode') == true ? ThemeMode.dark : ThemeMode.light;
  Locale locale = storage.read('isBangla') == true ? const Locale('bn', 'BD') : const Locale('en', 'US');

  runApp(
    GetMaterialApp(
      title: AppConfig.instance.appTitle,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: AppConfig.instance.environment != AppEnvironment.prod,
      
      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Translations
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),

      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: SafeArea(top: false, bottom: true, child: child!),
      ),
    ),
  );
}
