import 'app/core/values/app_env.dart';
import 'app/main_common.dart';

void main() {
  AppConfig.setConfig(
    AppConfig(
      baseUrl: 'https://dev-api.example.com',
      environment: AppEnvironment.dev,
      appTitle: 'Cylinder Hub Dev',
    ),
  );
  mainCommon();
}
