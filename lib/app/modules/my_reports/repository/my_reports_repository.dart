

import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/report_model.dart';

class MyReportsRepository extends BaseRepository {
  MyReportsRepository({required super.apiClient});

  Future<ApiResponse<SalesmanReport>> getReport(int userId, {String? from, String? to}) async {
    final response = await apiClient.get(
      Endpoints.salesmanReport(userId),
      queryParameters: {
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      },
    );
    return ApiResponse<SalesmanReport>.fromJson(
      response.data,
      (json) => SalesmanReport.fromJson(json as Map<String, dynamic>),
    );
  }
}
