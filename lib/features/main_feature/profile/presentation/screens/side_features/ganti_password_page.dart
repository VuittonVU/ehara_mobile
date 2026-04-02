import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widgets/app_background.dart';
import '../../../../../../core/widgets/app_status_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
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

  void _showSuccessDialog() {
    AppStatusDialog.show(
      context: context,
      title: 'Password Berhasil Diganti!',
      message: 'Password kamu sudah berhasil diperbarui.',
      imagePath: 'assets/maskot/maskot2.png',
      buttonText: 'Kembali',
      onPressed: () {
        Navigator.pop(context); // tutup dialog
        context.pop(); // balik ke profil
      },
    );
  }

  void _handleChangePassword() {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showErrorDialog(
        title: 'Data Tidak Lengkap!',
        message: 'Semua field password wajib diisi.',
      );
      return;
    }

    if (oldPass == newPass) {
      _showErrorDialog(
        title: 'Password Tidak Valid!',
        message: 'Password baru harus berbeda dengan password lama.',
      );
      return;
    }

    if (newPass != confirmPass) {
      _showErrorDialog(
        title: 'Konfirmasi Salah!',
        message: 'Konfirmasi password baru tidak cocok.',
      );
      return;
    }

    _showSuccessDialog();
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
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF6E6E6E),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Image.asset(
                'assets/icons/arrow_back.png',
                width: 28,
                height: 28,
              ),
            ),
          ),
          const Text(
            'Ganti Password',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2F2F2F),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
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
                            controller: oldPasswordController,
                            obscureText: _obscureOldPassword,
                            onToggleVisibility: () {
                              setState(() {
                                _obscureOldPassword = !_obscureOldPassword;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildPasswordField(
                            label: 'Password Baru',
                            controller: newPasswordController,
                            obscureText: _obscureNewPassword,
                            onToggleVisibility: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildPasswordField(
                            label: 'Konfirmasi Password Baru',
                            controller: confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            onToggleVisibility: () {
                              setState(() {
                                _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: 220,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _handleChangePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E7F69),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
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