import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/order_detail/order_detail_screen.dart';
import '../../features/order_list/order_list_screen.dart';
import '../../features/route_map/route_map_screen.dart';
import '../widgets/root_scaffold.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/orders',
    routes: [
      ShellRoute(
        builder: (context, state, child) => RootScaffold(child: child),
        routes: [
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (context, state) => const OrderListScreen(),
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => const RouteMapScreen(),
          ),
          GoRoute(
            path: '/order/:id',
            name: 'order-detail',
            builder: (context, state) {
              final orderId = state.pathParameters['id']!;
              return OrderDetailScreen(orderId: orderId);
            },
          ),
        ],
      ),
    ],
  );
});