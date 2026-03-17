import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

class RootScaffold extends ConsumerWidget {
  const RootScaffold({super.key, required this.child});
  
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final location = router.routerDelegate.currentConfiguration.uri.path;
    final isOrderDetail = location.startsWith('/order/');

    return Scaffold(
      body: child,
      bottomNavigationBar: isOrderDetail
          ? null
          : BottomNavigationBar(
              currentIndex: location == '/map' ? 1 : 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Route',
                ),
              ],
              onTap: (index) {
                context.go(index == 0 ? '/orders' : '/map');
              },
            ),
    );
  }
}