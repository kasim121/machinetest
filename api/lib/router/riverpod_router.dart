import 'package:go_router/go_router.dart';
import 'package:api/screens/riverpod/riverpod_rest_screen.dart';
import 'package:api/screens/riverpod/riverpod_post_screen.dart';

final GoRouter riverpodRouter = GoRouter(
  initialLocation: '/riverpod/restaurants',
  routes: [
    GoRoute(
      path: '/riverpod/restaurants',
      builder: (context, state) => const RiverpodRestaurantScreen(),
    ),
    GoRoute(
      path: '/riverpod/posts',
      builder: (context, state) => const RiverpodPostScreen(),
    ),
  ],
);
