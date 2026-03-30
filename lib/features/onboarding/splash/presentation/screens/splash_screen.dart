import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Timer? _timer;

  @override
  void initState() {
    super.initState();

    // _startNavigationTimer();
  }

  // void _startNavigationTimer() {
  //   _timer = Timer(const Duration(seconds: 2), () {
  //     if (!mounted) return;
  //     context.go(AppRoutes.walkthrough);
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  void _goNext() {
    context.go(AppRoutes.walkthrough);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: GestureDetector(
        onTap: _goNext,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash/background.png',
              fit: BoxFit.cover,
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    Center(
                      child: Transform.translate(
                        offset: const Offset(10, 0),
                        child: Image.asset(
                          'assets/images/logo/logo_ehara.png',
                          width: 210,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/splash/tagline.png',
                            width: 150,
                            filterQuality: FilterQuality.high,
                          ),

                          const SizedBox(height: 16),

                          Container(
                            width: 220,
                            height: 2,
                            color: AppColors.primary,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Pusat Penelitian Kelapa Sawit',
                            style: AppTextStyles.regular(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}