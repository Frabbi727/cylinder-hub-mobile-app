

import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/user_model.dart';

class ProfileRepository extends BaseRepository {
  ProfileRepository({required super.apiClient});

  Future<ApiResponse<User>> getProfile() async {
    final response = await apiClient.get(Endpoints.me);
    return ApiResponse<User>.fromJson(
      response.data,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> logout() async {
    final response = await apiClient.post(Endpoints.logout);
    return ApiResponse<void>.fromJson(
      response.data,
      (json) {},
    );
  }
}
