import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/sale_detail/bindings/sale_detail_binding.dart';
import '../modules/sale_detail/views/sale_detail_view.dart';
import '../modules/customers/bindings/customer_binding.dart';
import '../modules/customers/views/customer_list_view.dart';
import '../modules/customers/views/customer_detail_view.dart';
import '../modules/end_of_day/bindings/end_of_day_binding.dart';
import '../modules/end_of_day/views/end_of_day_view.dart';
import '../modules/empty_returns/bindings/empty_returns_binding.dart';
import '../modules/empty_returns/views/empty_returns_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/my_reports/bindings/my_reports_binding.dart';
import '../modules/my_reports/views/my_reports_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.MAIN_NAVIGATION,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: Routes.SALE_DETAIL,
      page: () => const SaleDetailView(),
      binding: SaleDetailBinding(),
    ),
    GetPage(
      name: Routes.CUSTOMER_LIST,
      page: () => const CustomerListView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.CUSTOMER_DETAIL,
      page: () => const CustomerDetailView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.END_OF_DAY,
      page: () => const EndOfDayView(),
      binding: EndOfDayBinding(),
    ),
    GetPage(
      name: Routes.EMPTY_RETURNS,
      page: () => const EmptyReturnsView(),
      binding: EmptyReturnsBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: Routes.MY_REPORTS,
      page: () => const MyReportsView(),
      binding: MyReportsBinding(),
    ),
  ];
}
