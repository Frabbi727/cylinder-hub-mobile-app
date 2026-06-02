import 'package:get/get.dart';
import '../controllers/my_day_controller.dart';

class MyDayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyDayController>(() => MyDayController());
  }
}
