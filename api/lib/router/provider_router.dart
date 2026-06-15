import 'package:go_router/go_router.dart';
import 'package:api/screens/provider/provider_rest_screen.dart';
import 'package:api/screens/provider/provider_post_screen.dart';

final GoRouter providerRouter = GoRouter(
  initialLocation: '/provider/restaurants',
  routes: [
    GoRoute(
      path: '/provider/restaurants',
      builder: (context, state) => const RestaurantScreen(),
    ),
    GoRoute(
      path: '/provider/posts',
      builder: (context, state) => const PostScreen(),
    ),
  ],
);
