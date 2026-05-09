import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../core/network/api_client.dart';
import '../core/utils/constants.dart';
import '../data/datasources/post_remote_data_source.dart';
import '../data/repositories/post_repository_impl.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/usecases/get_post_by_id.dart';
import '../domain/usecases/get_posts.dart';
import '../presentation/bloc/post_bloc.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // External dependencies
  sl.registerLazySingleton(() => http.Client());

  // Core
  sl.registerLazySingleton(
    () => ApiClient(client: sl(), baseUrl: AppConstants.baseUrl),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => GetPostById(sl()));

  // BLoC
  sl.registerFactory(() => PostBloc(getPosts: sl()));
}
