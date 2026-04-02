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

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.riwayat)) return 1;
    if (location.startsWith(AppRoutes.pembayaran)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;

    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.riwayat);
        break;
      case 2:
        context.push(AppRoutes.form1);
        break;
      case 3:
        context.go(AppRoutes.pembayaran);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}