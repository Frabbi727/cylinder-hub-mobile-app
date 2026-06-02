import '../../../core/base/base_repository.dart';

class HomeRepository extends BaseRepository {
  HomeRepository({required super.apiClient});

  Future<List<String>> getHomeData() async {
    // Example: final response = await apiClient.get('/home');
    // return (response.data as List).map((e) => e.toString()).toList();
    return ['Real Item 1', 'Real Item 2'];
  }
}
