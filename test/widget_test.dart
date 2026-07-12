// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cylinder_hub_mobile_app/app/app.dart';
import 'package:cylinder_hub_mobile_app/app/core/values/app_env.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cylinder_hub_mobile_app/app/core/services/connectivity_service.dart';
import 'package:cylinder_hub_mobile_app/app/data/api/api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock path_provider to support GetStorage initialization
  const MethodChannel pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    pathProviderChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.';
      }
      return null;
    },
  );

  // Mock connectivity_plus method channel check method
  const MethodChannel connectivityChannel = MethodChannel('dev.fluttercommunity.plus/connectivity');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    connectivityChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'check') {
        return ['wifi'];
      }
      return null;
    },
  );

  setUpAll(() async {
    GetStorage.init();
    AppConfig.setConfig(
      AppConfig(
        baseUrl: 'https://test-api.com',
        environment: AppEnvironment.dev,
        appTitle: 'Test App',
      ),
    );
    Get.put(ApiClient(), permanent: true);
    Get.put(ConnectivityService(), permanent: true);
  });

  testWidgets('Splash Screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CylinderHubApp());

    // Verify that splash screen icon exists (our placeholder icon)
    // expect(find.byIcon(Icons.flash_on), findsOneWidget);
  });
}
