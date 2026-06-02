enum AppEnvironment { dev, staging, prod }

class AppConfig {
  final String baseUrl;
  final AppEnvironment environment;
  final String appTitle;
  final String apiKey; // Example of a sensitive key

  AppConfig({
    required this.baseUrl,
    required this.environment,
    required this.appTitle,
    this.apiKey = '',
  });

  static late AppConfig _instance;
  static AppConfig get instance => _instance;

  static void setConfig(AppConfig config) {
    _instance = config;
  }
}
