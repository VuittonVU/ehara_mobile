import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/login_text_field.dart';
import '../widgets/social_login_button.dart';
import '../../../../core/widgets/app_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint('Email / Username: $email');
    debugPrint('Password: $password');

    // TODO: sambungkan ke Firebase Auth / backend login
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email/Username dan Password wajib diisi'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login button pressed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 36),

                    Image.asset(
                      'assets/images/logo/logo_ehara.png',
                      width: 150,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Sign In',
                      style: AppTextStyles.displayMedium(),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Silahkan masuk dengan akun Anda.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular(
                        fontSize: 14,
                        color: AppColors.textPrimary.withOpacity(0.75),
                      ),
                    ),

                    const SizedBox(height: 34),

                    SocialLoginButton(
                      text: 'Sign in dengan Google',
                      iconPath: 'assets/images/icons/google.png',
                      onTap: () {},
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'Atau menggunakan Email',
                            style: AppTextStyles.regular(
                              fontSize: 13,
                              color: AppColors.textPrimary.withOpacity(0.72),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    LoginTextField(
                      controller: emailController,
                      hintText: 'Email / Username',
                      iconPath: 'assets/images/icons/email.png',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 18),

                    LoginTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      iconPath: 'assets/images/icons/lock.png',
                      obscureText: isPasswordHidden,
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
                          color: AppColors.textPrimary.withOpacity(0.4),
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
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
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Masuk',
                          style: AppTextStyles.semiBold(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppTextStyles.regular(
                            fontSize: 14,
                            color: AppColors.textPrimary.withOpacity(0.78),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
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
                          color: AppColors.textPrimary.withOpacity(0.5),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 28, top: 32),
                      child: Column(
                        children: [
                          Container(
                            width: 160,
                            height: 2,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Pusat Penelitian Kelapa Sawit',
                            style: AppTextStyles.regular(
                              fontSize: 13,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}