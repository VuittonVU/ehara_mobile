import '../models/notifikasi_model.dart';

class NotificationData {
  static const List<NotificationModel> notifications = [
    NotificationModel(
      title: 'Login Terdeteksi',
      message: 'Akun E-HARA baru saja masuk dari perangkat lain. Jika bukan kamu, segera amankan akun.',
      dateTime: '16 Maret 2026 • 14.16',
      type: NotificationType.security,
    ),
    NotificationModel(
      title: 'Reset Password',
      message: 'Ada permintaan reset password untuk akunmu. Abaikan jika bukan kamu.',
      dateTime: '16 Maret 2026 • 14.16',
      type: NotificationType.security,
    ),
    NotificationModel(
      title: 'Sertifikat Siap',
      message: 'Sertifikat analisis sudah terbit. Kamu bisa mengunduhnya di menu riwayat.',
      dateTime: '16 Maret 2026 • 14.16',
      type: NotificationType.certificate,
    ),
    NotificationModel(
      title: 'Sertifikat Diproses',
      message: 'Sertifikat sedang divalidasi oleh tim PPKS. Kami akan kabari jika sudah selesai.',
      dateTime: '16 Maret 2026 • 14.16',
      type: NotificationType.certificate,
    ),
    NotificationModel(
      title: 'Pembayaran Dibutuhkan',
      message: 'Selesaikan pembayaran agar laporan lengkap bisa dibuka. Cek detailnya di menu riwayat.',
      dateTime: '16 Maret 2026 • 14.16',
      type: NotificationType.payment,
    ),
    NotificationModel(
      title: 'Pembayaran Diterima',
      message: 'Pembayaran sudah berhasil diverifikasi. Laporan lengkap sudah bisa diakses.',
      dateTime: '16 Maret 2026 • 14.16',
      type: NotificationType.payment,
    ),
  ];
}