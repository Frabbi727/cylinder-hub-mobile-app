import 'app/core/values/app_env.dart';
import 'app/core/values/constants.dart';
import 'app/main_common.dart';

void main() {
  AppConfig.setConfig(
    AppConfig(
      baseUrl: Constants.stagingBaseUrl,
      environment: AppEnvironment.staging,
      appTitle: 'Cylinder Hub Staging',
      apiKey: 'staging_key_12345',
    ),
  );
  mainCommon();
}
