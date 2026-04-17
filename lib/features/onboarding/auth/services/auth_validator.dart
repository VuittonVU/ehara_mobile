class AuthValidator {
  static String? validateLoginIdentifier(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Email atau username wajib diisi.';
    }

    if (trimmed.contains('@')) {
      return validateGmail(trimmed);
    }

    return validateUsername(trimmed);
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

  static String? validateFullName(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Nama lengkap wajib diisi.';
    }

    if (trimmed.length < 3) {
      return 'Nama lengkap minimal 3 karakter.';
    }

    final nameRegex = RegExp(r"^[A-Za-z\s.'-]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Nama lengkap hanya boleh huruf dan tanda umum.';
    }

    return null;
  }

  static String? validateUsername(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Username wajib diisi.';
    }

    if (trimmed.length < 3) {
      return 'Username minimal 3 karakter.';
    }

    if (trimmed.length > 20) {
      return 'Username maksimal 20 karakter.';
    }

    final usernameRegex = RegExp(r'^[A-Za-z0-9._]+$');
    if (!usernameRegex.hasMatch(trimmed)) {
      return 'Username hanya boleh huruf, angka, titik, atau underscore.';
    }

    return null;
  }

  static String? validateAddress(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Alamat wajib diisi.';
    }

    if (trimmed.length < 5) {
      return 'Alamat terlalu pendek.';
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

    if (trimmed.length < 10) {
      return '$fieldName minimal 10 digit.';
    }

    if (trimmed.length > 15) {
      return '$fieldName maksimal 15 digit.';
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
      return 'Password harus punya minimal 1 huruf besar.';
    }

    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSymbol =
    RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(password);

    if (!hasNumber && !hasSymbol) {
      return 'Password harus punya minimal 1 angka atau simbol.';
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
}