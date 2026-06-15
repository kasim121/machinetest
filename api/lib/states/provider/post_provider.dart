import 'package:flutter/material.dart';
import 'package:api/models/post.dart';
import 'package:api/service/service.dart';

enum ApiStatus { initial, loading, success, error }

class PostViewProvider extends ChangeNotifier {
  final ApiService apiService;
  PostViewProvider(this.apiService);

  ApiStatus _apiStatus = ApiStatus.initial;
  String? _errorMessage;
  List<Post> _posts = [];

  ApiStatus get apiStatus => _apiStatus;
  String? get errorMessage => _errorMessage;
  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    try {
      _apiStatus = ApiStatus.loading;
      _errorMessage = null;
      notifyListeners();

      _posts = await apiService.getPosts();
      _apiStatus = ApiStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _apiStatus = ApiStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
