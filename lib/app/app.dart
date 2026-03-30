import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/onboarding/auth/presentation/screens/login_screen.dart';
import '../features/onboarding/auth/presentation/screens/signup_screen.dart';
import '../features/onboarding/splash/presentation/screens/splash_screen.dart';
import '../features/onboarding/walkthrough/presentation/screens/walkthrough_screen.dart';
import 'routes/app_routes.dart';

class EHaraApp extends StatelessWidget {
  const EHaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.walkthrough,
          builder: (context, state) => const WalkthroughScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionDuration: const Duration(milliseconds: 450),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final fadeAnimation = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(animation);

              final slideAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.08),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              );

              return FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: child,
                ),
              );
            },
          ),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const SignUpScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'E-Hara',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}