import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/sale_model.dart';

class SalesRepository extends BaseRepository {
  SalesRepository({required super.apiClient});

  Future<ApiResponse<List<Sale>>> getSales({
    bool? today,
    bool? hasDue,
    String? from,
    String? to,
    String? paymentType,
    String? search,
    int? page,
  }) async {
    final response = await apiClient.get(
      Endpoints.sales,
      queryParameters: {
        if (today != null) 'today': today,
        if (hasDue != null) 'has_due': hasDue,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (paymentType != null) 'payment_type': paymentType,
        if (search != null) 'search': search,
        if (page != null) 'page': page,
      },
    );
    return ApiResponse<List<Sale>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Sale.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<Sale>> getSaleDetail(int saleId) async {
    final response = await apiClient.get(Endpoints.saleDetail(saleId));
    return ApiResponse<Sale>.fromJson(
      response.data,
      (json) => Sale.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Sale>> collectPayment(int saleId, double amount, String date, String? notes) async {
    final response = await apiClient.post(
      Endpoints.salePay(saleId),
      data: {
        'amount': amount,
        'date': date,
        if (notes != null) 'notes': notes,
      },
    );
    return ApiResponse<Sale>.fromJson(
      response.data,
      (json) => Sale.fromJson(json as Map<String, dynamic>),
    );
  }
}
