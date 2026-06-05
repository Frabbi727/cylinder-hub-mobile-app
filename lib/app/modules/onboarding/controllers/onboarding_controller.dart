import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends BaseController {
  final _storage = GetStorage();
  final pageController = PageController();
  final currentPage = 0.obs;

  static const int totalPages = 3;

  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void skip() => _finish();

  void _finish() {
    _storage.write('isFirstTime', false);
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
