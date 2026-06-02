import 'app/core/values/app_env.dart';
import 'app/core/values/constants.dart';
import 'app/main_common.dart';

void main() {
  AppConfig.setConfig(
    AppConfig(
      baseUrl: Constants.prodBaseUrl,
      environment: AppEnvironment.prod,
      appTitle: 'Cylinder Hub',
      apiKey: 'prod_key_12345',
    ),
  );
  mainCommon();
}
