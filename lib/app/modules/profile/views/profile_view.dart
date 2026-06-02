import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.profile.tr)),
      body: Center(child: Text(TranslationKeys.profile.tr)),
    );
  }
}
