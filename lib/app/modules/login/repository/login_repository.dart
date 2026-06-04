import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/user_model.dart';


class LoginRepository extends BaseRepository {
  LoginRepository({required super.apiClient});

  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    final response = await apiClient.post(
      Endpoints.login,
      data: {'email': email, 'password': password},
    );
    return ApiResponse<AuthResponse>.fromJson(
      response.data,
      (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
