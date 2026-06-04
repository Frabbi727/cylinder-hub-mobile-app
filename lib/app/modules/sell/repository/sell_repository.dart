

import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/cylinder_model.dart';
import '../../../data/models/sale_model.dart';

class SellRepository extends BaseRepository {
  SellRepository({required super.apiClient});

  Future<ApiResponse<List<Customer>>> getCustomers({String? search, int? page}) async {
    final response = await apiClient.get(
      Endpoints.customers,
      queryParameters: {
        if (search != null) 'search': search,
        if (page != null) 'page': page,
      },
    );
    return ApiResponse<List<Customer>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Customer.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<Customer>> addCustomer(String name, String? phone, String? address) async {
    final response = await apiClient.post(
      Endpoints.customers,
      data: {
        'name': name,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
      },
    );
    return ApiResponse<Customer>.fromJson(
      response.data,
      (json) => Customer.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<Cylinder>>> getCylinders() async {
    final response = await apiClient.get(Endpoints.cylinders);
    return ApiResponse<List<Cylinder>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Cylinder.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<Sale>> createSale({
    int? customerId,
    required String saleDate,
    required String paymentType,
    double? paidAmount,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await apiClient.post(
      Endpoints.sales,
      data: {
        'customer_id': customerId,
        'sale_date': saleDate,
        'payment_type': paymentType,
        if (paidAmount != null) 'paid_amount': paidAmount,
        if (notes != null) 'notes': notes,
        'items': items,
      },
    );
    return ApiResponse<Sale>.fromJson(
      response.data,
      (json) => Sale.fromJson(json as Map<String, dynamic>),
    );
  }
}
