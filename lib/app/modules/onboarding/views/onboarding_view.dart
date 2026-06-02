import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(TranslationKeys.onboarding.tr, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: controller.completeOnboarding,
              child: Text(TranslationKeys.getStarted.tr),
            ),
          ],
        ),
      ),
    );
  }
}
