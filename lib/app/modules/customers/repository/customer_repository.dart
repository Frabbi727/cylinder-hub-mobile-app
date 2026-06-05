import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/customer_response_models.dart';
import '../../../data/models/return_model.dart';
import '../../../data/models/sale_model.dart';

class CustomerRepository extends BaseRepository {
  CustomerRepository({required super.apiClient});

  Future<ApiResponse<List<Customer>>> getCustomers({String? search, int? page}) async {
    final response = await apiClient.get(
      Endpoints.customers,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (page != null) 'page': page,
      },
    );
    return ApiResponse<List<Customer>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Customer.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<Customer>> getCustomerDetail(int id) async {
    final response = await apiClient.get(Endpoints.customerDetail(id));
    return ApiResponse<Customer>.fromJson(
      response.data,
      (json) => Customer.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<Sale>>> getCustomerSales(int customerId) async {
    final response = await apiClient.get(
      Endpoints.sales,
      queryParameters: {'customer_id': customerId},
    );
    return ApiResponse<List<Sale>>.fromJson(
      response.data,
      (json) => (json as List).map((i) => Sale.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<CustomerEmptyResponse>> getCustomerEmpties(int id) async {
    final response = await apiClient.get(Endpoints.customerEmpties(id));
    return ApiResponse<CustomerEmptyResponse>.fromJson(
      response.data,
      (json) => CustomerEmptyResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Customer>> addCustomer(String name, String? phone, String? address) async {
    final response = await apiClient.post(
      Endpoints.customers,
      data: {
        'name': name,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (address != null && address.isNotEmpty) 'address': address,
      },
    );
    return ApiResponse<Customer>.fromJson(
      response.data,
      (json) => Customer.fromJson(json as Map<String, dynamic>),
    );
  }
}
