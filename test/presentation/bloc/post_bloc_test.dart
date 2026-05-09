import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloccicd/core/error/failures.dart';
import 'package:bloccicd/domain/entities/post.dart';
import 'package:bloccicd/domain/usecases/get_posts.dart';
import 'package:bloccicd/presentation/bloc/post_bloc.dart';
import 'package:bloccicd/presentation/bloc/post_event.dart';
import 'package:bloccicd/presentation/bloc/post_state.dart';

// Mock class for GetPosts use case
class MockGetPosts extends Mock implements GetPosts {}

void main() {
  late PostBloc postBloc;
  late MockGetPosts mockGetPosts;

  setUp(() {
    mockGetPosts = MockGetPosts();
    postBloc = PostBloc(getPosts: mockGetPosts);
  });

  tearDown(() {
    postBloc.close();
  });

  const tPost = Post(id: 1, userId: 1, title: 'Test Title', body: 'Test Body');

  const tPosts = [tPost];

  group('PostBloc', () {
    test('initial state should be PostInitial', () {
      expect(postBloc.state, equals(const PostInitial()));
    });

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] when data is fetched successfully',
      build: () {
        when(() => mockGetPosts()).thenAnswer((_) async => const Right(tPosts));
        return postBloc;
      },
      act: (bloc) => bloc.add(const LoadPostsEvent()),
      expect: () => [const PostLoading(), const PostLoaded(tPosts)],
      verify: (_) {
        verify(() => mockGetPosts()).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] when fetching data fails',
      build: () {
        when(
          () => mockGetPosts(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return postBloc;
      },
      act: (bloc) => bloc.add(const LoadPostsEvent()),
      expect: () => [const PostLoading(), const PostError('Server error')],
      verify: (_) {
        verify(() => mockGetPosts()).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoaded] when RefreshPostsEvent is added',
      build: () {
        when(() => mockGetPosts()).thenAnswer((_) async => const Right(tPosts));
        return postBloc;
      },
      act: (bloc) => bloc.add(const RefreshPostsEvent()),
      expect: () => [const PostLoaded(tPosts)],
      verify: (_) {
        verify(() => mockGetPosts()).called(1);
      },
    );
  });
}
