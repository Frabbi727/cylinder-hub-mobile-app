import 'app/core/values/app_env.dart';
import 'app/main_common.dart';

void main() {
  AppConfig.setConfig(
    AppConfig(
      baseUrl: 'https://api.example.com',
      environment: AppEnvironment.prod,
      appTitle: 'Cylinder Hub',
    ),
  );
  mainCommon();
}
