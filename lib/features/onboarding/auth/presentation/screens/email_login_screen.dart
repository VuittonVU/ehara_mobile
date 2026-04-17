import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../services/auth_validator.dart';
import '../widgets/login_text_field.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError =
      value.isEmpty ? null : AuthValidator.validateGmail(value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordError =
      value.isEmpty ? null : AuthValidator.validatePassword(value);
    });
  }

  bool get _isFormValid {
    return AuthValidator.validateGmail(emailController.text.trim()) == null &&
        AuthValidator.validatePassword(passwordController.text) == null;
  }

  Future<void> handleLogin() async {
    _validateEmail(emailController.text.trim());
    _validatePassword(passwordController.text);

    if (!_isFormValid || _isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() => _isLoading = false);
    context.go(AppRoutes.dashboard);
  }

  void _handleResetPassword() {
    _showInfo('Fitur lupa password belum tersedia.');
  }

  void _openPrivacyPolicy() {
    context.push(AppRoutes.privacyPolicy);
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
                          const SizedBox(height: 46),
                          Image.asset(
                            'assets/images/logo/logo_ehara.png',
                            width: 160,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 38),
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
                          LoginTextField(
                            controller: emailController,
                            hintText: 'Email Gmail',
                            iconPath: 'assets/icons/email.png',
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailError,
                            onChanged: _validateEmail,
                          ),
                          const SizedBox(height: 18),
                          LoginTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            iconPath: 'assets/icons/lock.png',
                            obscureText: isPasswordHidden,
                            errorText: _passwordError,
                            onChanged: _validatePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => handleLogin(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                              icon: Icon(
                                isPasswordHidden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textPrimary.withOpacity(0.40),
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _handleResetPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Lupa Password?',
                                style: AppTextStyles.medium(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                disabledBackgroundColor:
                                AppColors.primary.withOpacity(0.75),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                'Masuk',
                                style: AppTextStyles.semiBold(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum punya akun? ',
                                style: AppTextStyles.regular(
                                  fontSize: 14,
                                  color: AppColors.textPrimary.withOpacity(0.80),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.push(AppRoutes.signup);
                                },
                                child: Text(
                                  'Daftar',
                                  style: AppTextStyles.semiBold(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _openPrivacyPolicy,
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