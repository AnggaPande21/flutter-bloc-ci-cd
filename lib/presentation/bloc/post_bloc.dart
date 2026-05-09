import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import 'post_event.dart';
import 'post_state.dart';

/// BLoC for managing Post-related state and business logic
class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;

  PostBloc({required this.getPosts}) : super(const PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
  }

  /// Handler for LoadPostsEvent
  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());

    final result = await getPosts();

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostLoaded(posts)),
    );
  }

  /// Handler for RefreshPostsEvent
  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    final result = await getPosts();

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostLoaded(posts)),
    );
  }
}
