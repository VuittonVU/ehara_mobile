import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isGoogleLoading = false;

  Future<void> _handleGoogleLogin() async {
    if (_isGoogleLoading) return;

    setState(() => _isGoogleLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isGoogleLoading = false);

    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        mediaQuery.size.height -
            mediaQuery.padding.top -
            mediaQuery.padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight > 0
                        ? constraints.maxHeight
                        : screenHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 54),
                          Image.asset(
                            'assets/images/logo/logo_ehara.png',
                            width: 160,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 44),
                          Text(
                            'Sign In',
                            style: AppTextStyles.displayMedium(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Silahkan masuk dengan akun Anda.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regular(
                              fontSize: 14,
                              color: AppColors.textPrimary.withOpacity(0.74),
                            ),
                          ),
                          const SizedBox(height: 42),
                          AbsorbPointer(
                            absorbing: _isGoogleLoading,
                            child: SocialLoginButton(
                              text: _isGoogleLoading
                                  ? 'Sedang masuk...'
                                  : 'Sign in dengan Google',
                              iconPath: 'assets/icons/google.png',
                              onTap: _handleGoogleLogin,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black.withOpacity(0.10),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: Text(
                                  'Atau',
                                  style: AppTextStyles.regular(
                                    fontSize: 13,
                                    color: AppColors.textPrimary.withOpacity(0.62),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black.withOpacity(0.10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push(AppRoutes.emailLogin);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              label: Text(
                                'Sign in dengan Email',
                                style: AppTextStyles.semiBold(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Privacy Policy',
                              style: AppTextStyles.regular(
                                fontSize: 12,
                                color: AppColors.textPrimary.withOpacity(0.50),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32, top: 24),
                        child: Column(
                          children: [
                            Container(
                              width: 230,
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
              );
            },
          ),
        ),
      ),
    );
  }
}