class AuthValidator {
  static String? validateLoginIdentifier(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Email atau username wajib diisi.';
    }

    if (trimmed.contains('@')) {
      return validateGmail(trimmed);
    }

    if (trimmed.length < 3) {
      return 'Username minimal 3 karakter.';
    }

    final usernameRegex = RegExp(r'^[A-Za-z0-9._]+$');
    if (!usernameRegex.hasMatch(trimmed)) {
      return 'Username hanya boleh huruf, angka, titik, atau underscore.';
    }

    return null;
  }

  static String? validateGmail(String email) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      return 'Email wajib diisi.';
    }

    final emailRegex = RegExp(r'^[A-Za-z0-9._%+-]+@gmail\.com$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Email harus menggunakan @gmail.com.';
    }

    return null;
  }

  static String? validatePhoneNumber(String value, String fieldName) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return '$fieldName wajib diisi.';
    }

    final numberRegex = RegExp(r'^[0-9]+$');
    if (!numberRegex.hasMatch(trimmed)) {
      return '$fieldName hanya boleh berisi angka.';
    }

    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password wajib diisi.';
    }

    if (password.length < 8) {
      return 'Password minimal 8 karakter.';
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    if (!hasUppercase) {
      return 'Password harus memiliki minimal 1 huruf besar.';
    }

    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSymbol =
    RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(password);

    if (!hasNumber && !hasSymbol) {
      return 'Password harus memiliki minimal 1 angka atau simbol.';
    }

    return null;
  }

  static String? validateConfirmPassword(
      String password,
      String confirmPassword,
      ) {
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password wajib diisi.';
    }

    if (password != confirmPassword) {
      return 'Konfirmasi password tidak sama.';
    }

    return null;
  }

  static String? validateRequired(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return '$fieldName wajib diisi.';
    }
    return null;
  }
}