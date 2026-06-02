import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../repository/home_repository.dart';

class HomeController extends BaseController {
  final HomeRepository repository;

  HomeController({required this.repository});

  final _data = <String>[].obs;
  List<String> get data => _data;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    showLoading();
    try {
      // Simulate API call
      // final result = await repository.getHomeData();
      _data.assignAll(['Item 1', 'Item 2', 'Item 3']);
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }
}
