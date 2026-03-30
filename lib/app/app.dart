import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/walkthrough/presentation/screens/walkthrough_screen.dart';
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
        AppRoutes.walkthrough: (_) => const WalkthroughScreen(),
      },
    );
  }
}