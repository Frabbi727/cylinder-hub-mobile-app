import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../routes/app_pages.dart';
import '../repository/my_day_repository.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/models/allocation_model.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/models/user_model.dart';

class MyDayController extends BaseController {
  final MyDayRepository repository;
  final _authService = Get.find<AuthService>();

  // Reactive user from cached service
  User? get cachedUser => _authService.user.value;
  
  final stats = Rxn<DashboardStats>();
  final allocations = <Allocation>[].obs;
  final recentSales = <Sale>[].obs;
  
  final greeting = ''.obs;
  final todayDate = ''.obs;

  MyDayController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _updateTimeInfo();
    fetchDashboardData();
  }

  void _updateTimeInfo() {
    final now = DateTime.now();
    todayDate.value = DateFormat('MMMM d, yyyy').format(now);
    
    final hour = now.hour;
    if (hour < 12) {
      greeting.value = TranslationKeys.goodMorning.tr;
    } else if (hour < 17) {
      greeting.value = TranslationKeys.goodAfternoon.tr;
    } else {
      greeting.value = TranslationKeys.goodEvening.tr;
    }
  }

  Future<void> fetchDashboardData() async {
    if (cachedUser == null) return;
    
    showLoading();
    try {
      final response = await repository.getDashboardData(cachedUser!.id);
      if (response.success && response.data != null) {
        final data = response.data!;
        
        // Update user cache if API returns fresh user data
        if (data.salesman != null) {
          _authService.updateUser(data.salesman!);
        }

        stats.value = data.stats;
        recentSales.assignAll(data.todaySales ?? []);
        allocations.assignAll(data.salesman?.allocations ?? []);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  void onNotificationTap() => Get.toNamed(Routes.NOTIFICATIONS);
}
