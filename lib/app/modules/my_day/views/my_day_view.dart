import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../controllers/my_day_controller.dart';

class MyDayView extends GetView<MyDayController> {
  const MyDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.myDay.tr)),
      body: Center(child: Text(TranslationKeys.myDay.tr)),
    );
  }
}
