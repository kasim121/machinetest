import 'package:api/stateproviderblocriverpod/bloc/bloc.dart';
import 'package:api/stateproviderblocriverpod/bloc/restaurant_event.dart';
import 'package:api/stateproviderblocriverpod/bloc/restaurant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocRestaurantScreen extends StatefulWidget {
  const BlocRestaurantScreen({super.key});

  @override
  State<BlocRestaurantScreen> createState() => _BlocRestaurantScreenState();
}

class _BlocRestaurantScreenState extends State<BlocRestaurantScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<RestaurantBloc>().add(FetchRestaurants());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurants (Bloc)")),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantInitial) {
            return const Center(child: Text("No Data"));
          } else if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestaurantError) {
            return Center(child: Text(state.message));
          } else if (state is RestaurantSuccess) {
            final restaurants = state.response.restaurants;

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

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
