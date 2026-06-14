import 'package:api/stateproviderblocriverpod/riverpod/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodRestaurantScreen extends ConsumerStatefulWidget {
  const RiverpodRestaurantScreen({super.key});

  @override
  ConsumerState<RiverpodRestaurantScreen> createState() => _RiverpodRestaurantScreenState();
}

class _RiverpodRestaurantScreenState extends ConsumerState<RiverpodRestaurantScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(restaurantResponseProvider.notifier).fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = ref.watch(restaurantResponseProvider)?.restaurants ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Restaurants (Riverpod)")),
      body: restaurants.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
    );
  }
}
