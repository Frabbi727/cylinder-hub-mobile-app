import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../my_day/controllers/my_day_controller.dart';
import '../../sales/controllers/sales_controller.dart';
import '../../sell/controllers/sell_controller.dart';
import '../../dues/controllers/dues_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainNavigationController extends BaseController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changeIndex(int index) {
    _currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Pre-initialize controllers if needed, or rely on LazyPut in bindings
  }
}
