import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../widgets/error_display.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';

/// Main page displaying list of posts
class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  @override
  void initState() {
    super.initState();
    // Load posts when page is first opened
    context.read<PostBloc>().add(const LoadPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PostBloc>().add(const RefreshPostsEvent());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const LoadingIndicator(message: 'Loading posts...');
          }

          if (state is PostError) {
            return ErrorDisplay(
              message: state.message,
              onRetry: () {
                context.read<PostBloc>().add(const LoadPostsEvent());
              },
            );
          }

          if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const EmptyState(
                message: 'No posts available',
                icon: Icons.article_outlined,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(const RefreshPostsEvent());
                // Wait for the refresh to complete
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostCard(
                    post: post,
                    onTap: () => _navigateToDetail(context, post),
                  );
                },
              ),
            );
          }

          return const EmptyState(
            message: 'Pull to refresh or tap the refresh button',
            icon: Icons.refresh,
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
    );
  }
}
