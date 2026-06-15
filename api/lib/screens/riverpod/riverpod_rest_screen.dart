import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../states/riverpod/restaurent_notifier.dart';

class RiverpodRestaurantScreen extends ConsumerWidget {
  const RiverpodRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRestaurants = ref.watch(restaurantListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants (Riverpod)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.article),
            onPressed: () => context.push('/riverpod/posts'),
          ),
        ],
      ),
      body: asyncRestaurants.when(
        data: (restaurants) => restaurants.isEmpty
            ? const Center(child: Text('No restaurants'))
            : ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return Card(
                    child: ListTile(
                      title: Text(restaurant.name),
                      subtitle: Text(restaurant.cuisines.join(', ')),
                      trailing: Text(restaurant.rating.average.toString()),
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
