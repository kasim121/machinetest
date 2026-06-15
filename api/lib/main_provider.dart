import 'package:api/service/service.dart';
import 'package:api/stateproviderblocriverpod/provider/provider.dart';
import 'package:api/stateproviderblocriverpod/provider/post_provider.dart';
import 'package:api/screens/provider/provider_rest_screen.dart';
import 'package:api/screens/provider/provider_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as prov;
import 'package:go_router/go_router.dart';
import 'package:api/router/provider_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    prov.MultiProvider(
      providers: [
        prov.ChangeNotifierProvider(
          create: (_) => RestaurantViewProvider(ApiService()),
        ),
        prov.ChangeNotifierProvider(
          create: (_) => PostViewProvider(ApiService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: providerRouter);
  }
}
