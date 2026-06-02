import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

abstract class BaseController extends GetxController {
  final logger = Logger();
  final _storage = GetStorage();
  
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;
  set errorMessage(String value) => _errorMessage.value = value;

  void showLoading() => isLoading = true;
  void hideLoading() => isLoading = false;

import '../values/languages/translation_keys.dart';
// ... other imports

abstract class BaseController extends GetxController {
  // ...
  void handleError(String message) {
    errorMessage = message;
    Get.snackbar(TranslationKeys.error.tr, message, snackPosition: SnackPosition.BOTTOM);
  }
  // ...
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

  // Language Management
  void toggleLanguage() {
    if (Get.locale?.languageCode == 'en') {
      var locale = const Locale('bn', 'BD');
      Get.updateLocale(locale);
      _storage.write('isBangla', true);
    } else {
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
      _storage.write('isBangla', false);
    }
  }
}
