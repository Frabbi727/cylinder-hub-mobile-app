

import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/allocation_model.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/dashboard_model.dart';

class MyDayRepository extends BaseRepository {
  MyDayRepository({required super.apiClient});

  Future<ApiResponse<DashboardData>> getDashboardData(int userId) async {
    final response = await apiClient.get(Endpoints.salesmanDashboard(userId));
    return ApiResponse<DashboardData>.fromJson(
      response.data,
      (json) => DashboardData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Allocation>> reconcileAllocation(int allocationId, int soldQty, double collectedAmount) async {
    final response = await apiClient.post(
      Endpoints.reconcileAllocation(allocationId),
      data: {
        'sold_qty': soldQty,
        'collected_amount': collectedAmount,
      },
    );
    return ApiResponse<Allocation>.fromJson(
      response.data,
      (json) => Allocation.fromJson(json as Map<String, dynamic>),
    );
  }
}
