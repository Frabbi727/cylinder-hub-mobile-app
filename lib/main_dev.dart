import 'app/core/values/app_env.dart';
import 'app/core/values/constants.dart';
import 'app/main_common.dart';

void main() {
  AppConfig.setConfig(
    AppConfig(
      baseUrl: Constants.devBaseUrl,
      environment: AppEnvironment.dev,
      appTitle: 'Cylinder Hub Dev',
      apiKey: 'dev_key_12345',
    ),
  );
  mainCommon();
}
