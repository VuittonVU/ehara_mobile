import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/routes/app_routes.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../widgets/login_text_field.dart';
import '../widgets/social_login_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleRegister() {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final address = addressController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final whatsapp = whatsappController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (fullName.isEmpty ||
        username.isEmpty ||
        address.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        whatsapp.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi password tidak sama'),
        ),
      );
      return;
    }

    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
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
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 36),

                          Image.asset(
                            'assets/images/logo/logo_ehara.png',
                            width: 150,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 28),

                          Text(
                            'Sign Up',
                            style: AppTextStyles.displayMedium(),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Silahkan daftar akun baru Anda',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regular(
                              fontSize: 14,
                              color: AppColors.textPrimary.withOpacity(0.75),
                            ),
                          ),

                          const SizedBox(height: 34),

                          SocialLoginButton(
                            text: 'Sign up dengan Google',
                            iconPath: 'assets/images/icons/google.png',
                            onTap: () {},
                          ),

                          const SizedBox(height: 26),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'Atau menggunakan Email',
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
                                  height: 1,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          LoginTextField(
                            controller: fullNameController,
                            hintText: 'Nama Lengkap',
                            iconPath: 'assets/images/icons/user.png',
                          ),

                          const SizedBox(height: 16),

                          LoginTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            iconPath: 'assets/images/icons/at.png',
                          ),

                          const SizedBox(height: 16),

                          LoginTextField(
                            controller: addressController,
                            hintText: 'Alamat',
                            iconPath: 'assets/images/icons/location.png',
                          ),

                          const SizedBox(height: 16),

                          LoginTextField(
                            controller: emailController,
                            hintText: 'Email',
                            iconPath: 'assets/images/icons/email.png',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),

                          LoginTextField(
                            controller: phoneController,
                            hintText: 'Nomor Handphone',
                            iconPath: 'assets/images/icons/phone.png',
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 16),

                          _WhatsappField(
                            controller: whatsappController,
                          ),

                          const SizedBox(height: 16),

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

                          const SizedBox(height: 16),

                          LoginTextField(
                            controller: confirmPasswordController,
                            hintText: 'Konfirmasi Password',
                            iconPath: 'assets/images/icons/lock.png',
                            obscureText: isConfirmPasswordHidden,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordHidden =
                                  !isConfirmPasswordHidden;
                                });
                              },
                              icon: Icon(
                                isConfirmPasswordHidden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textPrimary.withOpacity(0.4),
                                size: 22,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.regular(
                                fontSize: 10,
                                color: AppColors.textPrimary.withOpacity(0.65),
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                  'Dengan menekan Daftar, Anda menyetujui ',
                                ),
                                TextSpan(
                                  text: 'Syarat dan Ketentuan (S&K)',
                                  style: AppTextStyles.semiBold(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' kami',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Daftar',
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
                                'Sudah punya akun? ',
                                style: AppTextStyles.regular(
                                  fontSize: 14,
                                  color: AppColors.textPrimary.withOpacity(
                                    0.78,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go(AppRoutes.login);
                                },
                                child: Text(
                                  'Masuk',
                                  style: AppTextStyles.semiBold(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 32, top: 24),
                        child: Column(
                          children: [
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WhatsappField extends StatelessWidget {
  final TextEditingController controller;

  const _WhatsappField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 54,
          width: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.textPrimary.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '+62',
            style: AppTextStyles.regular(
              fontSize: 14,
              color: AppColors.textPrimary.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: AppTextStyles.regular(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Nomor Whatsapp',
              hintStyle: AppTextStyles.regular(
                fontSize: 14,
                color: AppColors.textPrimary.withOpacity(0.45),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.92),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.textPrimary.withOpacity(0.4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.textPrimary.withOpacity(0.4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}