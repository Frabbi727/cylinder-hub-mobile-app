import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import '../values/languages/translation_keys.dart';

abstract class BaseController extends GetxController {
  final logger = Logger();
  final _storage = GetStorage();
  
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;
  set errorMessage(String value) => _errorMessage.value = value;

  // Added this to fix the Obx error in language buttons
  final currentLanguage = 'en'.obs;

  void showLoading() => isLoading = true;
  void hideLoading() => isLoading = false;

  void handleError(String message) {
    errorMessage = message;
    Get.snackbar(TranslationKeys.error.tr, message, snackPosition: SnackPosition.BOTTOM);
  }

  // Theme Management
  void toggleTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      _storage.write('isDarkMode', false);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      _storage.write('isDarkMode', true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Synchronize currentLanguage with the actual locale on startup
    currentLanguage.value = Get.locale?.languageCode ?? 'en';
  }

  // Language Management
  void toggleLanguage() {
    print("BaseController: Current locale before toggle: ${Get.locale?.languageCode}");
    if (Get.locale?.languageCode == 'en') {
      var locale = const Locale('bn', 'BD');
      Get.updateLocale(locale);
      currentLanguage.value = 'bn';
      _storage.write('isBangla', true);
      print("BaseController: Switched to BN");
    } else {
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
      currentLanguage.value = 'en';
      _storage.write('isBangla', false);
      print("BaseController: Switched to EN");
    }
  }
}
