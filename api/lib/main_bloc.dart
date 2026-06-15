import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api/service/service.dart';
import 'package:api/stateproviderblocriverpod/bloc/restaurents/restaurent_bloc.dart';
import 'package:api/stateproviderblocriverpod/bloc/posts/post_bloc.dart';
import 'package:api/router/bloc_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantBloc>(
          create: (_) => RestaurantBloc(ApiService()),
        ),
        BlocProvider<PostBloc>(
          create: (_) => PostBloc(ApiService()),
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
    return MaterialApp.router(
      title: 'MachineTest - Bloc Demo',
      routerConfig: blocRouter,
    );
  }
}
