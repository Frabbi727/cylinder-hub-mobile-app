import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/cylinder_model.dart';
import '../../../data/models/return_model.dart';

class EmptyReturnsRepository extends BaseRepository {
  EmptyReturnsRepository({required super.apiClient});

  Future<ApiResponse<List<Cylinder>>> getCylinders() async {
    final response = await apiClient.get(Endpoints.cylinders);
    return ApiResponse<List<Cylinder>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Cylinder.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<List<Customer>>> getCustomers({String? search}) async {
    final response = await apiClient.get(
      Endpoints.customers,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return ApiResponse<List<Customer>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Customer.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<CylinderReturn>> createReturn({
    required int cylinderId,
    required int qty,
    required String returnDate,
    int? customerId,
    required String type,
    required bool isExtra,
    String? extraReason,
    String? notes,
  }) async {
    final response = await apiClient.post(
      Endpoints.returns,
      data: {
        'cylinder_id': cylinderId,
        'qty': qty,
        'return_date': returnDate,
        if (customerId != null) 'customer_id': customerId,
        'type': type,
        'is_extra': isExtra,
        if (extraReason != null && extraReason.isNotEmpty) 'extra_reason': extraReason,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return ApiResponse<CylinderReturn>.fromJson(
      response.data,
      (json) => CylinderReturn.fromJson(json as Map<String, dynamic>),
    );
  }
}
