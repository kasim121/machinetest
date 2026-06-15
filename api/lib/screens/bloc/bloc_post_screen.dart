import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api/states/bloc/posts/post_bloc.dart';
import 'package:api/states/bloc/posts/post_event.dart';
import 'package:api/states/bloc/posts/post_state.dart';
import 'package:api/screens/widgets/post_detail_screen.dart';

class BlocPostScreen extends StatefulWidget {
  const BlocPostScreen({super.key});

  @override
  State<BlocPostScreen> createState() => _BlocPostScreenState();
}

class _BlocPostScreenState extends State<BlocPostScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching posts via the bloc when the widget is first inserted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        context.read<PostBloc>().add(FetchPosts());
      } catch (e) {
        // If PostBloc is not provided, we silently ignore here, but consider providing the bloc at a higher level.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts (Bloc)')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else if (state is PostLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) return const Center(child: Text('No posts'));
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
                    ),
                  ),
                );
              },
            );
          }

          // Initial / fallback state
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
