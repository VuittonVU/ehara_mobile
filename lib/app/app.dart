import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import 'routes/app_routes.dart';

class EHaraApp extends StatelessWidget {
  const EHaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Hara',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const Placeholder(),
      },
    );
  }
}