import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/sell_controller.dart';

class SellView extends GetView<SellController> {
  const SellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.sell.tr)),
      body: Center(child: Text(TranslationKeys.sell.tr)),
    );
  }
}
