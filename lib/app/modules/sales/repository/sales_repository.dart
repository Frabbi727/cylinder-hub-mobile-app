import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/models/sale_response_models.dart';

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
        'today': ?today,
        'has_due': ?hasDue,
        'from': ?from,
        'to': ?to,
        'payment_type': ?paymentType,
        'search': ?search,
        'page': ?page,
      },
    );
    return ApiResponse<List<Sale>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Sale.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<SaleDetailResponse>> getSaleDetail(int saleId) async {
    final response = await apiClient.get(Endpoints.saleDetail(saleId));
    return ApiResponse<SaleDetailResponse>.fromJson(
      response.data,
      (json) => SaleDetailResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<SaleDetailResponse>> collectPayment(int saleId, double amount, String date, String? notes) async {
    final response = await apiClient.post(
      Endpoints.salePay(saleId),
      data: {
        'amount': amount,
        'date': date,
        if (notes != null) 'notes': notes,
      },
    );
    return ApiResponse<SaleDetailResponse>.fromJson(
      response.data,
      (json) => SaleDetailResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
