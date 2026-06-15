import 'package:api/service/service.dart';
import 'package:api/models/restaurant_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final restaurantResponseProvider = StateNotifierProvider<RestaurantNotifier, ApiResponse?>(
  (ref) => RestaurantNotifier(ref.read(apiServiceProvider)),
);

class RestaurantNotifier extends StateNotifier<ApiResponse?> {
  final ApiService apiService;
  RestaurantNotifier(this.apiService) : super(null);

  Future<void> fetchRestaurants() async {
    final resp = await apiService.getRestaurants();
    state = resp;
  }
}
