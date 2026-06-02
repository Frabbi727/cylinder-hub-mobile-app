enum AppEnvironment { dev, staging, prod }

class AppConfig {
  final String baseUrl;
  final AppEnvironment environment;
  final String appTitle;

  AppConfig({
    required this.baseUrl,
    required this.environment,
    required this.appTitle,
  });

  static late AppConfig _instance;
  static AppConfig get instance => _instance;

  static void setConfig(AppConfig config) {
    _instance = config;
  }
}
