import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_sizes.dart';
import '../controllers/home_controller.dart';

import '../../../core/values/languages/translation_keys.dart';
// ... other imports

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationKeys.home.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: controller.toggleLanguage,
          ),
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: controller.toggleTheme,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.data.isEmpty) {
          return Center(
            child: Text(
              TranslationKeys.noData.tr,
              style: const TextStyle(fontSize: AppSizes.f18),
            ),
          );
        }
// ...

        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.p16),
          itemCount: controller.data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                controller.data[index],
                style: const TextStyle(fontSize: AppSizes.f16),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
