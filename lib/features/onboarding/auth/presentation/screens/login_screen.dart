import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../services/auth_service.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  void _showSnackBar(
      String message, {
        Color? backgroundColor,
        int seconds = 4,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: seconds),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleGoogleLogin() async {
    if (_isGoogleLoading) return;

    setState(() => _isGoogleLoading = true);

    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId:
        '1088379536347-upgn3p7fodrdnqh2cvd0rf6125ku1e0v.apps.googleusercontent.com',
      );

      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      final googleUser = await googleSignIn.signIn();

      if (!mounted) return;

      if (googleUser == null) {
        _showSnackBar(
          'Login Google dibatalkan.',
          backgroundColor: Colors.orange,
        );
        return;
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw Exception('Token Google tidak ditemukan.');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final firebaseIdToken = await userCredential.user?.getIdToken(true);

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        throw Exception('Firebase ID Token tidak ditemukan.');
      }

      debugPrint('FIREBASE ID TOKEN: $firebaseIdToken');

      final result = await AuthService().loginWithGoogleIdToken(
        idToken: firebaseIdToken,
      );

      if (!mounted) return;

      _showSnackBar(
        result['message']?.toString() ?? 'Login Google berhasil',
        backgroundColor: Colors.green,
        seconds: 2,
      );

      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) return;
      context.go(AppRoutes.dashboard);
    } catch (e, stackTrace) {
      debugPrint('GOOGLE ERROR TYPE: ${e.runtimeType}');
      debugPrint('GOOGLE ERROR: $e');
      debugPrint('GOOGLE STACK: $stackTrace');

      if (!mounted) return;

      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        seconds: 5,
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handleAppleLoginTest() async {
    if (_isAppleLoading) return;

    setState(() => _isAppleLoading = true);

    try {
      await FirebaseAuth.instance.signOut();

      final appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');

      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

      final user = userCredential.user;
      final firebaseIdToken = await user?.getIdToken(true);

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        throw Exception('Firebase ID Token Apple tidak ditemukan.');
      }

      debugPrint('APPLE FIREBASE UID: ${user?.uid}');
      debugPrint('APPLE EMAIL: ${user?.email}');
      debugPrint('APPLE DISPLAY NAME: ${user?.displayName}');
      debugPrint('APPLE FIREBASE ID TOKEN: $firebaseIdToken');

      try {
        final result = await AuthService().loginWithFirebaseIdToken(
          provider: 'apple',
          idToken: firebaseIdToken,
        );

        if (!mounted) return;

        _showSnackBar(
          result['message']?.toString() ?? 'Login Apple berhasil',
          backgroundColor: Colors.green,
          seconds: 2,
        );

        await Future.delayed(const Duration(milliseconds: 400));

        if (!mounted) return;
        context.go(AppRoutes.dashboard);
      } catch (apiError, apiStackTrace) {
        debugPrint('APPLE CALLBACK API ERROR TYPE: ${apiError.runtimeType}');
        debugPrint('APPLE CALLBACK API ERROR: $apiError');
        debugPrint('APPLE CALLBACK API STACK: $apiStackTrace');

        if (!mounted) return;

        _showSnackBar(
          'Apple/Firebase sudah aktif. API E-Hara masih gagal: '
          '${apiError.toString().replaceFirst('Exception: ', '')}',
          backgroundColor: Colors.orange,
          seconds: 7,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('APPLE ERROR TYPE: ${e.runtimeType}');
      debugPrint('APPLE ERROR: $e');
      debugPrint('APPLE STACK: $stackTrace');

      if (!mounted) return;

      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        seconds: 6,
      );
    } finally {
      if (mounted) {
        setState(() => _isAppleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height -
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
                            absorbing: _isGoogleLoading || _isAppleLoading,
                            child: SocialLoginButton(
                              text: _isGoogleLoading
                                  ? 'Sedang masuk...'
                                  : 'Sign in dengan Google',
                              iconPath: 'assets/icons/google.png',
                              onTap: _handleGoogleLogin,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AbsorbPointer(
                            absorbing: _isGoogleLoading || _isAppleLoading,
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: _handleAppleLoginTest,
                                icon: const Icon(Icons.apple, size: 22),
                                label: Text(
                                  _isAppleLoading
                                      ? 'Mengecek Apple...'
                                      : 'Sign in dengan Apple',
                                  style: AppTextStyles.semiBold(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.2,
                                  color: Colors.black.withOpacity(0.22),
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
                                    color: AppColors.textPrimary.withOpacity(
                                      0.72,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1.2,
                                  color: Colors.black.withOpacity(0.22),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
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
                              child: Text(
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
                            onPressed: () {
                              context.push(AppRoutes.privacyPolicy);
                            },
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