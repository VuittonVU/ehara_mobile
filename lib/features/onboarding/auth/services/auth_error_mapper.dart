String mapFirebaseAuthError(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'user-not-found':
      return 'Akun tidak ditemukan.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Email atau password salah.';
    case 'email-already-in-use':
      return 'Email sudah terdaftar.';
    case 'weak-password':
      return 'Password terlalu lemah.';
    case 'network-request-failed':
      return 'Koneksi internet bermasalah.';
    case 'google-sign-in-cancelled':
    case 'canceled':
      return 'Login Google dibatalkan.';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    default:
      return 'Terjadi kesalahan. Coba lagi.';
  }
}