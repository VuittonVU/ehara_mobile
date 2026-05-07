String mapAuthError(Object error) {
  final raw = error.toString().replaceFirst('Exception: ', '');
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

  if (message.contains('email has already') ||
      message.contains('email already') ||
      message.contains('email sudah') ||
      message.contains('email telah')) {
    return 'Email sudah terdaftar.';
  }

  if (message.contains('username has already') ||
      message.contains('username already') ||
      message.contains('username sudah') ||
      message.contains('username telah')) {
    return 'Username sudah digunakan.';
  }

  if (message.contains('validation') ||
      message.contains('validator') ||
      message.contains('invalid') ||
      message.contains('422')) {
    return 'Data belum sesuai. Periksa kembali input yang diisi.';
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

  return raw;
}