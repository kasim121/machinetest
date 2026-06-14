import 'package:api/service/service.dart';
import 'package:api/stateproviderblocriverpod/provider/provider.dart';
import 'package:api/screens/provider_rest_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // optional but safe

  runApp(
    // MultiProvider version (commented out). Use this when you need to register multiple providers:
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (_) => RestaurantViewProvider(ApiService()),
    //     ),
    //     // Add other providers here
    //   ],
    //   child: const MyApp(),
    // ),

    // Single provider version (active):
    ChangeNotifierProvider<RestaurantViewProvider>(
      create: (_) => RestaurantViewProvider(ApiService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: RestaurantScreen());
  }
}
