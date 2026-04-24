String mapAuthError(Object error) {
  final raw = error.toString();
  final message = raw.toLowerCase();

  if (message.contains('endpoint pendaftaran belum tersedia')) {
    return 'Endpoint pendaftaran belum tersedia dari backend PPKS.';
  }

  if (message.contains('token tidak ditemukan')) {
    return 'Sesi login tidak ditemukan. Silakan login ulang.';
  }

  if (message.contains('socketexception') ||
      message.contains('failed host lookup') ||
      message.contains('connection refused')) {
    return 'Tidak dapat terhubung ke server.';
  }

  if (message.contains('timeout')) {
    return 'Koneksi timeout. Coba lagi.';
  }

  if (message.contains('401') || message.contains('unauthorized')) {
    return 'Email/username atau password salah.';
  }

  if (message.contains('403')) {
    return 'Akses ditolak oleh server.';
  }

  if (message.contains('404')) {
    return 'Endpoint tidak ditemukan.';
  }

  if (message.contains('500')) {
    return 'Server sedang bermasalah.';
  }

  return raw.replaceFirst('Exception: ', '');
}