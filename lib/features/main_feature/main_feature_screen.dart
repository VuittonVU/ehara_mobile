import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_bottom_navbar.dart';

class MainFeatureScreen extends StatelessWidget {
  final Widget child;

  const MainFeatureScreen({
    super.key,
    required this.child,
  });

  static const List<String> _tabRoutes = [
    AppRoutes.dashboard,
    AppRoutes.riwayat,
    '', // tombol tengah = form
    AppRoutes.pembayaran,
    AppRoutes.profile,
  ];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.riwayat)) return 1;
    if (location.startsWith(AppRoutes.pembayaran)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;

    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 2) {
      context.push(AppRoutes.form1);
      return;
    }

    final targetRoute = _tabRoutes[index];
    if (targetRoute.isNotEmpty) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}