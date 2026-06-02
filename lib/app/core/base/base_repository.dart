import '../../data/api/api_client.dart';

abstract class BaseRepository {
  final ApiClient apiClient;

  BaseRepository({required this.apiClient});
}
