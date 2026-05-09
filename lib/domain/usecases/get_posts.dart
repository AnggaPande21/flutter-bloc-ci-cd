import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

/// Use case for fetching all posts
class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  /// Executes the use case to fetch all posts
  Future<Either<Failure, List<Post>>> call() async {
    return await repository.getPosts();
  }
}
