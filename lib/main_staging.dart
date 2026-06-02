import 'app/core/values/app_env.dart';
import 'app/main_common.dart';

void main() {
  AppConfig.setConfig(
    AppConfig(
      baseUrl: 'https://staging-api.example.com',
      environment: AppEnvironment.staging,
      appTitle: 'Cylinder Hub Staging',
    ),
  );
  mainCommon();
}
