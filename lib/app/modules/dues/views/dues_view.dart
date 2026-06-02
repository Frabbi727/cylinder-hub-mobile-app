import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/dues_controller.dart';

class DuesView extends GetView<DuesController> {
  const DuesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.dues.tr)),
      body: Center(child: Text(TranslationKeys.dues.tr)),
    );
  }
}
