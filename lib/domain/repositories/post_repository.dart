import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/post.dart';

/// Repository contract for Post operations
abstract class PostRepository {
  /// Fetches all posts from the data source
  /// Returns `Either<Failure, List<Post>>`
  Future<Either<Failure, List<Post>>> getPosts();

  /// Fetches a single post by ID
  /// Returns `Either<Failure, Post>`
  Future<Either<Failure, Post>> getPostById(int id);
}
