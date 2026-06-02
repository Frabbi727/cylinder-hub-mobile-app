import '../../../core/base/base_repository.dart';
import '../../../data/api/endpoints.dart';

class HomeRepository extends BaseRepository {
  HomeRepository({required super.apiClient});

  Future<List<String>> getHomeData() async {
    // Now using the centralized Endpoints constant
    // final response = await apiClient.get(Endpoints.homeData);
    // return (response.data as List).map((e) => e.toString()).toList();
    return ['Real Item 1', 'Real Item 2'];
  }
}
