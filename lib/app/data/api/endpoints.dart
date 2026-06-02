class Endpoints {
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // Home Endpoints
  static const String homeData = '/home/dashboard';

  // User Endpoints
  static const String profile = '/user/profile';
  
  // Sales Endpoints
  static const String salesList = '/sales/list';
  static const String createSale = '/sales/create';

  // Receive Timeout (inherited from constants if needed)
  static const int connectionTimeout = 30000;
}
