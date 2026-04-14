class ChangePasswordState {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final bool obscureOldPassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final bool isSubmitting;

  const ChangePasswordState({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.obscureOldPassword,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.isSubmitting,
  });

  factory ChangePasswordState.initial() {
    return const ChangePasswordState(
      oldPassword: '',
      newPassword: '',
      confirmPassword: '',
      obscureOldPassword: true,
      obscureNewPassword: true,
      obscureConfirmPassword: true,
      isSubmitting: false,
    );
  }

  ChangePasswordState copyWith({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    bool? obscureOldPassword,
    bool? obscureNewPassword,
    bool? obscureConfirmPassword,
    bool? isSubmitting,
  }) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscureOldPassword: obscureOldPassword ?? this.obscureOldPassword,
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      obscureConfirmPassword:
      obscureConfirmPassword ?? this.obscureConfirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}