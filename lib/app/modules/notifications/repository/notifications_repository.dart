import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/notification_model.dart';

class NotificationsRepository extends BaseRepository {
  NotificationsRepository({required super.apiClient});

  Future<ApiResponse<List<AppNotification>>> getNotifications() async {
    final response = await apiClient.get(Endpoints.notifications);
    return ApiResponse<List<AppNotification>>.fromJson(
      response.data,
      (json) =>
          (json as List).map((i) => AppNotification.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  Future<ApiResponse<void>> markRead(int id) async {
    final response = await apiClient.post(Endpoints.readNotification(id));
    return ApiResponse<void>.fromJson(response.data, (json) {});
  }

  Future<ApiResponse<void>> markAllRead() async {
    final response = await apiClient.post(Endpoints.readAllNotifications);
    return ApiResponse<void>.fromJson(response.data, (json) {});
  }
}
