import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../repository/my_reports_repository.dart';
import '../../../data/models/report_model.dart';

class MyReportsController extends BaseController {
  final MyReportsRepository repository;
  final report = Rxn<SalesmanReport>();

  MyReportsController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchReport();
  }

  Future<void> fetchReport() async {
    // We need the user ID. Normally stored in a SessionService or UserStore.
    // For now, let's assume we have it or can get it from the token/profile.
    // Assuming userId is available globally or fetched from Auth service.
    showLoading();
    try {
      // Dummy user ID 2 for now as per docs
      final response = await repository.getReport(2);
      if (response.success && response.data != null) {
        report.value = response.data;
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }
}
