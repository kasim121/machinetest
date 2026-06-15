import 'package:api/service/service.dart';
import 'package:api/models/restaurant_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final restaurantApiProvider = StateNotifierProvider<RestaurantNotifier, AsyncValue<ApiResponse>>(
  (ref) => RestaurantNotifier(ref.read(apiServiceProvider)),
);

class RestaurantNotifier extends StateNotifier<AsyncValue<ApiResponse>> {
  final ApiService apiService;
  RestaurantNotifier(this.apiService) : super(const AsyncValue.loading()) {
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    state = const AsyncValue.loading();
    try {
      final resp = await apiService.getRestaurants();
      state = AsyncValue.data(resp);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => fetchRestaurants();
}
