import 'package:api/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api/models/post.dart';
import 'package:api/screens/widgets/post_detail_screen.dart';

final postServiceProvider = Provider<ApiService>((ref) => ApiService());
final postsProvider = FutureProvider<List<Post>>((ref) async {
  final svc = ref.read(postServiceProvider);
  return svc.getPosts();
});

class RiverpodPostScreen extends ConsumerWidget {
  const RiverpodPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(postsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Posts (Riverpod)')),
      body: asyncPosts.when(
        data: (posts) => ListView.builder(
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
        ),
        error: (e, st) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
