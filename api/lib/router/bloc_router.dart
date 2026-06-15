import 'package:go_router/go_router.dart';
import 'package:api/screens/bloc/bloc_rest_screen.dart';
import 'package:api/screens/bloc/bloc_post_screen.dart';

final GoRouter blocRouter = GoRouter(
  initialLocation: '/bloc/restaurants',
  routes: [
    GoRoute(
      path: '/bloc/restaurants',
      builder: (context, state) => const BlocRestaurantScreen(),
    ),
    GoRoute(
      path: '/bloc/posts',
      builder: (context, state) => const BlocPostScreen(),
    ),
  ],
);
