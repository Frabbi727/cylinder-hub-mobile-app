import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/sales_controller.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.sales.tr)),
      body: Center(child: Text(TranslationKeys.sales.tr)),
    );
  }
}
