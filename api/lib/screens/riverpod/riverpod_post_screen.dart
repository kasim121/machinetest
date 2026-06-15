import 'package:api/states/riverpod/post_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';




class RiverpodPostScreen extends ConsumerWidget {
  const RiverpodPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(postNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Posts (Riverpod)')),
      body: asyncPosts.when(
        data: (posts) => posts.isEmpty
            ? const Center(child: Text('No posts'))
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    child: ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                      onTap: () => context.push('/riverpod/post', extra: post),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
