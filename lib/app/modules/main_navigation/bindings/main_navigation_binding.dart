import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../../my_day/controllers/my_day_controller.dart';
import '../../sales/controllers/sales_controller.dart';
import '../../sell/controllers/sell_controller.dart';
import '../../dues/controllers/dues_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    
    // Bind all tab controllers
    Get.lazyPut<MyDayController>(() => MyDayController());
    Get.lazyPut<SalesController>(() => SalesController());
    Get.lazyPut<SellController>(() => SellController());
    Get.lazyPut<DuesController>(() => DuesController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
