import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';

class MainNavigationController extends BaseController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changeIndex(int index) {
    _currentIndex.value = index;
  }
}
