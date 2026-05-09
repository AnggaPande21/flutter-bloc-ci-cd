import 'package:equatable/equatable.dart';

/// Base class for all PostBloc events
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

/// Event to load all posts
class LoadPostsEvent extends PostEvent {
  const LoadPostsEvent();
}

/// Event to refresh posts
class RefreshPostsEvent extends PostEvent {
  const RefreshPostsEvent();
}
