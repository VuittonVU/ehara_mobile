import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';

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
  //     Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  void _goNext() {
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      ///  Tap di mana aja
      body: GestureDetector(
        onTap: _goNext,
        child: Stack(
          fit: StackFit.expand,
          children: [

            /// Background
            Image.asset(
              'assets/images/splash/background.png',
              fit: BoxFit.cover,
            ),

            /// Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    const Spacer(flex: 3),

                    /// Logo
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

                    /// Tagline + garis + text
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [

                          /// Tagline
                          Image.asset(
                            'assets/images/splash/tagline.png',
                            width: 150,
                            filterQuality: FilterQuality.high,
                          ),

                          const SizedBox(height: 16),

                          /// Garis
                          Container(
                            width: 220,
                            height: 2,
                            color: AppColors.primary,
                          ),

                          const SizedBox(height: 10),

                          /// Text bawah
                          const Text(
                            'Pusat Penelitian Kelapa Sawit',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w400,
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