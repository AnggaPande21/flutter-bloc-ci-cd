import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

/// Use case for fetching a single post by ID
class GetPostById {
  final PostRepository repository;

  GetPostById(this.repository);

  /// Executes the use case to fetch a post by ID
  Future<Either<Failure, Post>> call(int id) async {
    return await repository.getPostById(id);
  }
}
