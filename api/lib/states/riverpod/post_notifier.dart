import 'package:api/service/service.dart';
import 'package:api/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'restaurent_notifier.dart';


final postNotifierProvider = StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>(
  (ref) => PostNotifier(ref.read(apiServiceProvider)),
);

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final ApiService apiService;
  PostNotifier(this.apiService) : super(const AsyncValue.loading()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final posts = await apiService.getPosts();
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => fetchPosts();
}
