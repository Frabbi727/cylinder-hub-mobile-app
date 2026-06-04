import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../controllers/main_navigation_controller.dart';

import '../../my_day/controllers/my_day_controller.dart';
import '../../my_day/repository/my_day_repository.dart';

import '../../sales/controllers/sales_controller.dart';
import '../../sales/repository/sales_repository.dart';

import '../../sell/controllers/sell_controller.dart';
import '../../sell/repository/sell_repository.dart';

import '../../dues/controllers/dues_controller.dart';
import '../../dues/repository/dues_repository.dart';

import '../../profile/controllers/profile_controller.dart';
import '../../profile/repository/profile_repository.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    
    // Bind all tab controllers with their respective repositories
    Get.lazyPut<MyDayController>(() => MyDayController(
      repository: MyDayRepository(apiClient: apiClient)
    ));
    
    Get.lazyPut<SalesController>(() => SalesController(
      repository: SalesRepository(apiClient: apiClient)
    ));
    
    Get.lazyPut<SellController>(() => SellController(
      repository: SellRepository(apiClient: apiClient)
    ));
    
    Get.lazyPut<DuesController>(() => DuesController(
      repository: DuesRepository(apiClient: apiClient)
    ));
    
    Get.lazyPut<ProfileController>(() => ProfileController(
      repository: ProfileRepository(apiClient: apiClient)
    ));
  }
}
