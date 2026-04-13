import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../services/auth_validator.dart';
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
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  String? _fullNameError;
  String? _usernameError;
  String? _addressError;
  String? _emailError;
  String? _phoneError;
  String? _whatsappError;
  String? _passwordError;
  String? _confirmPasswordError;

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

  void _validateFullName(String value) {
    setState(() {
      _fullNameError = value.isEmpty
          ? null
          : AuthValidator.validateRequired(value, 'Nama lengkap');
    });
  }

  void _validateUsername(String value) {
    setState(() {
      _usernameError = value.isEmpty
          ? null
          : AuthValidator.validateRequired(value, 'Username');
    });
  }

  void _validateAddress(String value) {
    setState(() {
      _addressError =
      value.isEmpty ? null : AuthValidator.validateRequired(value, 'Alamat');
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError = value.isEmpty ? null : AuthValidator.validateGmail(value);
    });
  }

  void _validatePhone(String value) {
    setState(() {
      _phoneError = value.isEmpty
          ? null
          : AuthValidator.validatePhoneNumber(value, 'Nomor handphone');
    });
  }

  void _validateWhatsapp(String value) {
    setState(() {
      _whatsappError = value.isEmpty
          ? null
          : AuthValidator.validatePhoneNumber(value, 'Nomor WhatsApp');
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordError =
      value.isEmpty ? null : AuthValidator.validatePassword(value);

      if (confirmPasswordController.text.isNotEmpty) {
        _confirmPasswordError = AuthValidator.validateConfirmPassword(
          value,
          confirmPasswordController.text,
        );
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      _confirmPasswordError = value.isEmpty
          ? null
          : AuthValidator.validateConfirmPassword(
        passwordController.text,
        value,
      );
    });
  }

  bool get _isFormValid {
    return AuthValidator.validateRequired(
      fullNameController.text,
      'Nama lengkap',
    ) ==
        null &&
        AuthValidator.validateRequired(usernameController.text, 'Username') ==
            null &&
        AuthValidator.validateRequired(addressController.text, 'Alamat') ==
            null &&
        AuthValidator.validateGmail(emailController.text.trim()) == null &&
        AuthValidator.validatePhoneNumber(
          phoneController.text,
          'Nomor handphone',
        ) ==
            null &&
        AuthValidator.validatePhoneNumber(
          whatsappController.text,
          'Nomor WhatsApp',
        ) ==
            null &&
        AuthValidator.validatePassword(passwordController.text) == null &&
        AuthValidator.validateConfirmPassword(
          passwordController.text,
          confirmPasswordController.text,
        ) ==
            null;
  }

  void _validateAll() {
    _validateFullName(fullNameController.text.trim());
    _validateUsername(usernameController.text.trim());
    _validateAddress(addressController.text.trim());
    _validateEmail(emailController.text.trim());
    _validatePhone(phoneController.text.trim());
    _validateWhatsapp(whatsappController.text.trim());
    _validatePassword(passwordController.text);
    _validateConfirmPassword(confirmPasswordController.text);
  }

  Future<void> handleRegister() async {
    _validateAll();

    if (!_isFormValid || _isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    context.go(AppRoutes.dashboard);
  }

  Future<void> _handleGoogleSignUp() async {
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
                          const SizedBox(height: 36),
                          Image.asset(
                            'assets/images/logo/logo_ehara.png',
                            width: 160,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 30),
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
                              color: AppColors.textPrimary.withOpacity(0.74),
                            ),
                          ),
                          const SizedBox(height: 30),
                          AbsorbPointer(
                            absorbing: _isGoogleLoading,
                            child: SocialLoginButton(
                              text: _isGoogleLoading
                                  ? 'Sedang masuk...'
                                  : 'Sign up dengan Google',
                              iconPath: 'assets/icons/google.png',
                              onTap: _handleGoogleSignUp,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black.withOpacity(0.10),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'Atau menggunakan Email',
                                  style: AppTextStyles.regular(
                                    fontSize: 13,
                                    color:
                                    AppColors.textPrimary.withOpacity(0.62),
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
                          const SizedBox(height: 24),
                          LoginTextField(
                            controller: fullNameController,
                            hintText: 'Nama Lengkap',
                            iconPath: 'assets/icons/user.png',
                            errorText: _fullNameError,
                            onChanged: _validateFullName,
                          ),
                          const SizedBox(height: 16),
                          LoginTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            iconPath: 'assets/icons/at.png',
                            errorText: _usernameError,
                            onChanged: _validateUsername,
                          ),
                          const SizedBox(height: 16),
                          LoginTextField(
                            controller: addressController,
                            hintText: 'Alamat',
                            iconPath: 'assets/icons/location.png',
                            errorText: _addressError,
                            onChanged: _validateAddress,
                          ),
                          const SizedBox(height: 16),
                          LoginTextField(
                            controller: emailController,
                            hintText: 'Email',
                            iconPath: 'assets/icons/email.png',
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailError,
                            onChanged: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          LoginTextField(
                            controller: phoneController,
                            hintText: 'Nomor Handphone',
                            iconPath: 'assets/icons/phone.png',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            errorText: _phoneError,
                            onChanged: _validatePhone,
                          ),
                          const SizedBox(height: 16),
                          _WhatsappField(
                            controller: whatsappController,
                            errorText: _whatsappError,
                            onChanged: _validateWhatsapp,
                          ),
                          const SizedBox(height: 16),
                          LoginTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            iconPath: 'assets/icons/lock.png',
                            obscureText: isPasswordHidden,
                            textInputAction: TextInputAction.next,
                            errorText: _passwordError,
                            onChanged: _validatePassword,
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
                          const SizedBox(height: 16),
                          LoginTextField(
                            controller: confirmPasswordController,
                            hintText: 'Konfirmasi Password',
                            iconPath: 'assets/icons/lock.png',
                            obscureText: isConfirmPasswordHidden,
                            textInputAction: TextInputAction.done,
                            errorText: _confirmPasswordError,
                            onChanged: _validateConfirmPassword,
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
                                color: AppColors.textPrimary.withOpacity(0.40),
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
                                  text: 'Dengan menekan Daftar, Anda menyetujui ',
                                ),
                                TextSpan(
                                  text: 'Syarat dan Ketentuan (S&K)',
                                  style: AppTextStyles.semiBold(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const TextSpan(text: ' kami'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : handleRegister,
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
                                  color: AppColors.textPrimary.withOpacity(0.80),
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

class _WhatsappField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _WhatsappField({
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = errorText != null
        ? Colors.red.withOpacity(0.65)
        : AppColors.textPrimary.withOpacity(0.22);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 54,
              width: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                '+62',
                style: AppTextStyles.regular(
                  fontSize: 14,
                  color: AppColors.textPrimary.withOpacity(0.72),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: onChanged,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: AppTextStyles.regular(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Nomor WhatsApp',
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
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: errorText != null ? Colors.red : AppColors.primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppTextStyles.regular(
                fontSize: 12,
                color: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}