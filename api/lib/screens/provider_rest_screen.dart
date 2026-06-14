import 'package:api/stateproviderblocriverpod/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<RestaurantViewProvider>().fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurants")),
      body: Consumer<RestaurantViewProvider>(
        builder: (context, vm, child) {
          switch (vm.apiStatus) {
            case ApiStatus.initial:
              return const Center(child: Text("No Data"));

            case ApiStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case ApiStatus.error:
              return Center(
                child: Text(vm.errorMessage ?? "Something went wrong"),
              );

            case ApiStatus.success:
              final restaurants = vm.restaurantResponse?.restaurants ?? [];

              return ListView.builder(
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
              );
          }
        },
      ),
    );
  }
}
