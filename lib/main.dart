import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/values/languages/translations.dart';
import 'app/data/api/api_client.dart';
import 'app/routes/app_pages.dart';

void main() async {
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
      title: "Cylinder Hub",
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
    ),
  );
}
