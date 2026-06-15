import 'package:api/states/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api/screens/widgets/post_detail_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PostViewProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts (Provider)')),
      body: Consumer<PostViewProvider>(
        builder: (context, vm, child) {
          switch (vm.apiStatus) {
            case ApiStatus.initial:
              return const Center(child: Text('No Data'));
            case ApiStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ApiStatus.error:
              return Center(child: Text(vm.errorMessage ?? 'Error'));
            case ApiStatus.success:
              final posts = vm.posts;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    child: ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
                        );
                      },
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
