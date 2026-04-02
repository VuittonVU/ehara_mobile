import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes/app_routes.dart';

import '../core/theme/app_theme.dart';
import '../features/onboarding/auth/presentation/screens/login_screen.dart';
import '../features/onboarding/auth/presentation/screens/signup_screen.dart';
import '../features/onboarding/splash/presentation/screens/splash_screen.dart';
import '../features/onboarding/walkthrough/presentation/screens/walkthrough_screen.dart';

import '../features/main_feature/main_feature_screen.dart';

import '../features/main_feature/dashboard/presentation/screens/dashboard_page.dart';
import '../features/main_feature/notifikasi/presentation/screens/notifikasi_page.dart';

import '../features/main_feature/riwayat/presentation/screens/riwayat_page.dart';

import '../features/main_feature/form/presentation/screens/form1.dart';
import '../features/main_feature/form/presentation/screens/form2.dart';
import '../features/main_feature/form/presentation/screens/form3.dart';
import '../features/main_feature/form/presentation/screens/form3_map.dart';

import '../features/main_feature/pembayaran/presentation/screens/pembayaran_page.dart';

import '../features/main_feature/profile/presentation/screens/profile_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/detail_profile_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/ganti_password_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/settings_notifikasi.dart';
import '../features/main_feature/profile/presentation/screens/side_features/about_app_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/legal_placeholder_page.dart';


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

        ShellRoute(
          builder: (context, state, child) {
            return MainFeatureScreen(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardPage(),
            ),
            GoRoute(
              path: AppRoutes.riwayat,
              builder: (context, state) => const RiwayatPage(),
            ),
            GoRoute(
              path: AppRoutes.pembayaran,
              builder: (context, state) => const PembayaranPage(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),

        GoRoute(
          path: AppRoutes.notifikasi,
          builder: (context, state) => const NotificationPage(),
        ),
        GoRoute(
          path: AppRoutes.form1,
          builder: (context, state) => const Form1Page(),
        ),
        GoRoute(
          path: AppRoutes.form2,
          builder: (context, state) => const Form2Page(),
        ),
        GoRoute(
          path: AppRoutes.form3Map,
          builder: (context, state) => const Form3MapPage(),
        ),
        GoRoute(
          path: AppRoutes.form3,
          builder: (context, state) {
            final data = state.extra as Map<String, double>;

            return Form3Page(
              selectedLatitude: data['lat']!,
              selectedLongitude: data['lng']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.detailProfil,
          builder: (context, state) => const DetailProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.changePassword,
          builder: (context, state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.notifikasiSettings,
          builder: (context, state) => const NotificationSettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.aboutApp,
          builder: (context, state) => const AboutAppPage(),
        ),
        GoRoute(
          path: AppRoutes.termsPlaceholder,
          builder: (context, state) => const LegalPlaceholderPage(
            title: 'Syarat & Ketentuan',
          ),
        ),
        GoRoute(
          path: AppRoutes.privacyPlaceholder,
          builder: (context, state) => const LegalPlaceholderPage(
            title: 'Kebijakan Privasi',
          ),
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