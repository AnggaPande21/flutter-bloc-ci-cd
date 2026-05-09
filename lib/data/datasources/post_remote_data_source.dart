import '../../core/network/api_client.dart';
import '../../core/utils/constants.dart';
import '../models/post_model.dart';

/// Remote data source for Post operations
abstract class PostRemoteDataSource {
  /// Fetches all posts from the API
  Future<List<PostModel>> getPosts();

  /// Fetches a single post by ID from the API
  Future<PostModel> getPostById(int id);
}

/// Implementation of PostRemoteDataSource using ApiClient
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await apiClient.get(AppConstants.postsEndpoint);

    if (response is List) {
      return response
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Invalid response format');
  }

  @override
  Future<PostModel> getPostById(int id) async {
    final response = await apiClient.get('${AppConstants.postsEndpoint}/$id');

    if (response is Map<String, dynamic>) {
      return PostModel.fromJson(response);
    }

    throw Exception('Invalid response format');
  }
}
