import 'package:equatable/equatable.dart';
import '../../../domain/entities/post.dart';

/// Base class for all PostBloc states
abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

/// Initial state when no posts are loaded
class PostInitial extends PostState {
  const PostInitial();
}

/// State when posts are being loaded
class PostLoading extends PostState {
  const PostLoading();
}

/// State when posts are successfully loaded
class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

/// State when there's an error loading posts
class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object> get props => [message];
}
