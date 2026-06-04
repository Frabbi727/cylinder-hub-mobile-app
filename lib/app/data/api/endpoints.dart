class Endpoints {
  // Auth
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Dashboard & Salesman
  static String salesmanDashboard(int id) => '/salesmen/$id';
  static String salesmanReport(int id) => '/salesmen/$id/report';
  static String salesmanDailyCollections(int id) => '/salesmen/$id/daily-collections';

  // Allocations
  static String reconcileAllocation(int id) => '/allocations/$id/reconcile';

  // Sales
  static const String sales = '/sales';
  static String saleDetail(int id) => '/sales/$id';
  static String salePay(int id) => '/sales/$id/pay';

  // Customers
  static const String customers = '/customers';
  static String customerDetail(int id) => '/customers/$id';
  static const String overdueCustomers = '/customers/overdue';
  static String customerEmpties(int id) => '/customers/$id/empties';

  // Cylinders
  static const String cylinders = '/cylinders';

  // Returns
  static const String returns = '/returns';

  // Notifications
  static const String notifications = '/notifications';
  static const String readAllNotifications = '/notifications/read-all';
  static String readNotification(int id) => '/notifications/$id/read';

  // Admin (Dashboard)
  static const String adminDashboard = '/dashboard';
}
