import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/widgets/app_background.dart';
import '../../../../../../core/widgets/app_status_dialog.dart';
import '../../../../../../core/widgets/pressable_button.dart';
import '../../../providers/side_features/change_pass/change_pass_controller.dart';
import '../../widgets/profile_header.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    final state = ref.read(changePasswordControllerProvider);

    _oldPasswordController = TextEditingController(text: state.oldPassword);
    _newPasswordController = TextEditingController(text: state.newPassword);
    _confirmPasswordController =
        TextEditingController(text: state.confirmPassword);

    _oldPasswordController.addListener(() {
      ref
          .read(changePasswordControllerProvider.notifier)
          .updateOldPassword(_oldPasswordController.text);
    });

    _newPasswordController.addListener(() {
      ref
          .read(changePasswordControllerProvider.notifier)
          .updateNewPassword(_newPasswordController.text);
    });

    _confirmPasswordController.addListener(() {
      ref
          .read(changePasswordControllerProvider.notifier)
          .updateConfirmPassword(_confirmPasswordController.text);
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog({
    required String title,
    required String message,
  }) {
    AppStatusDialog.show(
      context: context,
      title: title,
      message: message,
      imagePath: 'assets/maskot/maskot3.png',
      buttonText: 'Kembali',
      onPressed: () => Navigator.pop(context),
    );
  }

  void _showSuccessDialog({
    required String title,
    required String message,
  }) {
    AppStatusDialog.show(
      context: context,
      title: title,
      message: message,
      imagePath: 'assets/maskot/maskot2.png',
      buttonText: 'Kembali',
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _handleChangePassword() async {
    final result =
    await ref.read(changePasswordControllerProvider.notifier).submit();

    if (!mounted) return;

    if (result.isSuccess) {
      _showSuccessDialog(
        title: result.title,
        message: result.message,
      );
      return;
    }

    _showErrorDialog(
      title: result.title,
      message: result.message,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/icons/lock.png',
                width: 20,
                height: 20,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 46,
              minHeight: 46,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF5A5A5A),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: '**********',
            hintStyle: const TextStyle(
              color: Color(0xFF8A8A8A),
              letterSpacing: 1.2,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFC9C9C9),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF3E7F69),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              ProfileHeader(
                title: 'Ganti Password',
                onBackTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFD1D1D1),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildPasswordField(
                            label: 'Password Saat Ini',
                            controller: _oldPasswordController,
                            obscureText: state.obscureOldPassword,
                            onToggleVisibility: () {
                              ref
                                  .read(
                                changePasswordControllerProvider.notifier,
                              )
                                  .toggleOldPasswordVisibility();
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildPasswordField(
                            label: 'Password Baru',
                            controller: _newPasswordController,
                            obscureText: state.obscureNewPassword,
                            onToggleVisibility: () {
                              ref
                                  .read(
                                changePasswordControllerProvider.notifier,
                              )
                                  .toggleNewPasswordVisibility();
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildPasswordField(
                            label: 'Konfirmasi Password Baru',
                            controller: _confirmPasswordController,
                            obscureText: state.obscureConfirmPassword,
                            onToggleVisibility: () {
                              ref
                                  .read(
                                changePasswordControllerProvider.notifier,
                              )
                                  .toggleConfirmPasswordVisibility();
                            },
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: 220,
                            height: 48,
                            child: PressableButton(
                              onTap:
                              state.isSubmitting ? null : _handleChangePassword,
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFF3E7F69),
                              pressedScale: 0.98,
                              pressedTranslateY: 1.2,
                              idleTranslateY: -0.4,
                              child: Center(
                                child: state.isSubmitting
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                    : const Text(
                                  'Simpan Perubahan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Copyright © 2026 PPKS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}