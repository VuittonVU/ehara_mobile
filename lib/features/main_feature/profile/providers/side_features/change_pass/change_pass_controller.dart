import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'change_pass_state.dart';

final changePasswordControllerProvider = StateNotifierProvider.autoDispose<
    ChangePasswordController, ChangePasswordState>(
      (ref) => ChangePasswordController(),
);

class ChangePasswordController extends StateNotifier<ChangePasswordState> {
  ChangePasswordController() : super(ChangePasswordState.initial());

  void updateOldPassword(String value) {
    state = state.copyWith(oldPassword: value);
  }

  void updateNewPassword(String value) {
    state = state.copyWith(newPassword: value);
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void toggleOldPasswordVisibility() {
    state = state.copyWith(
      obscureOldPassword: !state.obscureOldPassword,
    );
  }

  void toggleNewPasswordVisibility() {
    state = state.copyWith(
      obscureNewPassword: !state.obscureNewPassword,
    );
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
  }

  Future<ChangePasswordResult> submit() async {
    final oldPass = state.oldPassword.trim();
    final newPass = state.newPassword.trim();
    final confirmPass = state.confirmPassword.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      return const ChangePasswordResult.error(
        title: 'Data Tidak Lengkap!',
        message: 'Semua field password wajib diisi.',
      );
    }

    if (oldPass == newPass) {
      return const ChangePasswordResult.error(
        title: 'Password Tidak Valid!',
        message: 'Password baru harus berbeda dengan password lama.',
      );
    }

    if (newPass != confirmPass) {
      return const ChangePasswordResult.error(
        title: 'Konfirmasi Salah!',
        message: 'Konfirmasi password baru tidak cocok.',
      );
    }

    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isSubmitting: false);

    return const ChangePasswordResult.success(
      title: 'Password Berhasil Diganti!',
      message: 'Password kamu sudah berhasil diperbarui.',
    );
  }
}

class ChangePasswordResult {
  final bool isSuccess;
  final String title;
  final String message;

  const ChangePasswordResult._({
    required this.isSuccess,
    required this.title,
    required this.message,
  });

  const ChangePasswordResult.success({
    required String title,
    required String message,
  }) : this._(
    isSuccess: true,
    title: title,
    message: message,
  );

  const ChangePasswordResult.error({
    required String title,
    required String message,
  }) : this._(
    isSuccess: false,
    title: title,
    message: message,
  );
}