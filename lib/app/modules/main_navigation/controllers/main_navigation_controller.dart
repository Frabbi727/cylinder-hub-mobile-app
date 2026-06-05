import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../my_day/controllers/my_day_controller.dart';
import '../../sales/controllers/sales_controller.dart';
import '../../sell/controllers/sell_controller.dart';
import '../../dues/controllers/dues_controller.dart';

class MainNavigationController extends BaseController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changeIndex(int index) {
    _currentIndex.value = index;
    _refreshTab(index);
  }

  void _refreshTab(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<MyDayController>()) Get.find<MyDayController>().refresh();
      case 1:
        if (Get.isRegistered<SalesController>()) Get.find<SalesController>().refresh();
      case 2:
        if (Get.isRegistered<SellController>()) Get.find<SellController>().refresh();
      case 3:
        if (Get.isRegistered<DuesController>()) Get.find<DuesController>().refresh();
    }
  }
}
