import 'package:api/service/service.dart';
import 'package:api/models/restaurant_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Expose a StateNotifierProvider that holds AsyncValue<List<Restaurant>> so UI can use .when()
final restaurantListProvider = StateNotifierProvider<RestaurantNotifier, AsyncValue<List<Restaurant>>>(
  (ref) => RestaurantNotifier(ref.read(apiServiceProvider)),
);

class RestaurantNotifier extends StateNotifier<AsyncValue<List<Restaurant>>> {
  final ApiService apiService;
  RestaurantNotifier(this.apiService) : super(const AsyncValue.loading()) {
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      final resp = await apiService.getRestaurants();
      state = AsyncValue.data(resp.restaurants);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => fetchRestaurants();
}
