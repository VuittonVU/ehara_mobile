import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes/app_routes.dart';

import '../core/theme/app_theme.dart';
import '../features/onboarding/auth/presentation/screens/login_screen.dart';
import '../features/onboarding/auth/presentation/screens/email_login_screen.dart';
import '../features/onboarding/auth/presentation/screens/signup_screen.dart';
import '../features/onboarding/splash/presentation/screens/splash_screen.dart';
import '../features/onboarding/walkthrough/presentation/screens/walkthrough_screen.dart';

import '../features/main_feature/main_feature_screen.dart';

import '../features/main_feature/dashboard/presentation/screens/dashboard_page.dart';
import '../features/main_feature/dashboard/models/article_model.dart';
import '../features/main_feature/dashboard/presentation/screens/article/article_detail_page.dart';
import '../features/main_feature/dashboard/presentation/screens/article/article_list_page.dart';

import '../features/main_feature/notifikasi/presentation/screens/notifikasi_page.dart';
import '../features/main_feature/riwayat/presentation/screens/riwayat_page.dart';

import '../features/main_feature/form/presentation/screens/form1.dart';
import '../features/main_feature/form/presentation/screens/form2.dart';
import '../features/main_feature/form/presentation/screens/form3.dart';
import '../features/main_feature/form/presentation/screens/form3_map.dart';

import '../features/main_feature/pembayaran/presentation/screens/pembayaran_page.dart';
import '../features/main_feature/pembayaran/presentation/screens/menu_pembayaran_page.dart';
import '../features/main_feature/pembayaran/presentation/screens/proses_pembayaran_page.dart';

import '../features/main_feature/profile/presentation/screens/profile_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/detail_profile_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/ganti_password_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/settings_notifikasi.dart';
import '../features/main_feature/profile/presentation/screens/side_features/about_app_page.dart';
import '../features/main_feature/profile/presentation/screens/side_features/legal_placeholder_page.dart';

class EHaraApp extends StatelessWidget {
  const EHaraApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.walkthrough,
        name: 'walkthrough',
        builder: (context, state) => const WalkthroughScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
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
        path: AppRoutes.emailLogin,
        builder: (context, state) => const EmailLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainFeatureScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.riwayat,
            name: 'riwayat',
            builder: (context, state) => const RiwayatPage(),
          ),
          GoRoute(
            path: AppRoutes.pembayaran,
            name: 'pembayaran',
            builder: (context, state) => const PembayaranPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.notifikasi,
        name: 'notifikasi',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: AppRoutes.form1,
        name: 'form1',
        builder: (context, state) => const Form1Page(),
      ),
      GoRoute(
        path: AppRoutes.form2,
        name: 'form2',
        builder: (context, state) => const Form2Page(),
      ),
      GoRoute(
        path: AppRoutes.form3Map,
        name: 'form3Map',
        builder: (context, state) => const Form3MapPage(),
      ),
      GoRoute(
        path: AppRoutes.form3,
        name: 'form3',
        builder: (context, state) => const Form3Page(),
      ),

      GoRoute(
        path: AppRoutes.articleList,
        name: 'articleList',
        builder: (context, state) {
          final articles = state.extra as List<ArticleModel>;
          return ArticleListPage(articles: articles);
        },
      ),
      GoRoute(
        path: AppRoutes.articleDetail,
        name: 'articleDetail',
        builder: (context, state) {
          final article = state.extra as ArticleModel;
          return ArticleDetailPage(article: article);
        },
      ),
      GoRoute(
        path: '/menu-pembayaran/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MenuPembayaranPage(pembayaranId: id);
        },
      ),
      GoRoute(
        path: '/proses-pembayaran/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProsesPembayaranPage(pembayaranId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.detailProfil,
        name: 'detailProfil',
        builder: (context, state) => const DetailProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.notifikasiSettings,
        name: 'notifikasiSettings',
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.aboutApp,
        name: 'aboutApp',
        builder: (context, state) => const AboutAppPage(),
      ),
      GoRoute(
        path: AppRoutes.termsPlaceholder,
        name: 'termsPlaceholder',
        builder: (context, state) => const LegalPlaceholderPage(
          title: 'Syarat & Ketentuan',
        ),
      ),
      GoRoute(
        path: AppRoutes.privacyPlaceholder,
        name: 'privacyPlaceholder',
        builder: (context, state) => const LegalPlaceholderPage(
          title: 'Kebijakan Privasi',
        ),
      ),

      // siap dipakai nanti buat detail hasil analisis/riwayat
      GoRoute(
        path: '${AppRoutes.detailRiwayat}/:id',
        name: 'detailRiwayat',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Riwayat')),
            body: Center(
              child: Text('Detail riwayat ID: $id'),
            ),
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'E-Hara',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}