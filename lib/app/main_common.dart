import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'app.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/auth_service.dart';
import 'data/api/api_client.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await GetStorage.init();
  
  // Inject global dependencies
  Get.put(ApiClient(), permanent: true);
  Get.put(ConnectivityService(), permanent: true);
  await Get.putAsync(() => AuthService().init(), permanent: true);

  runApp(const CylinderHubApp());
}
