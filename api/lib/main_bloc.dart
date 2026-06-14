import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api/service/service.dart';
import 'package:api/stateproviderblocriverpod/bloc/bloc.dart';
import 'package:api/screens/bloc_rest_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // MultiBlocProvider(
    //   providers: [
    //     BlocProvider<RestaurantBloc>(
    //       create: (_) => RestaurantBloc(ApiService()),
    //     ),
    //     // Add other BlocProviders here
    //   ],
    //   child: const MyApp(),
    // ),

    BlocProvider<RestaurantBloc>(
      create: (_) => RestaurantBloc(ApiService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BlocRestaurantScreen());
  }
}
