

import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/customer_model.dart';

class DuesRepository extends BaseRepository {
  DuesRepository({required super.apiClient});

  Future<ApiResponse<List<OverdueCustomer>>> getOverdueCustomers({int? days, String? sort}) async {
    final response = await apiClient.get(
      Endpoints.overdueCustomers,
      queryParameters: {
        if (days != null) 'days': days,
        if (sort != null) 'sort': sort,
      },
    );
    return ApiResponse<List<OverdueCustomer>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => OverdueCustomer.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }
}
