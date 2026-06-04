import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'core/services/connectivity_service.dart';
import 'data/api/api_client.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  
  // Inject global dependencies
  Get.put(ApiClient(), permanent: true);
  Get.put(ConnectivityService(), permanent: true);

  runApp(const CylinderHubApp());
}
