/*class AppUserModel {
  final String uid;
  final String namaLengkap;
  final String username;
  final String alamat;
  final String email;
  final String nomorHp;
  final String nomorWhatsapp;
  final bool akunGoogle;
  final bool notifikasiAktif;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUserModel({
    required this.uid,
    required this.namaLengkap,
    required this.username,
    required this.alamat,
    required this.email,
    required this.nomorHp,
    required this.nomorWhatsapp,
    required this.akunGoogle,
    required this.notifikasiAktif,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama_lengkap': namaLengkap,
      'username': username,
      'alamat': alamat,
      'email': email,
      'nomor_hp': nomorHp,
      'nomor_whatsapp': nomorWhatsapp,
      'akun_google': akunGoogle,
      'notifikasi_aktif': notifikasiAktif,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      uid: map['uid'] ?? '',
      namaLengkap: map['nama_lengkap'] ?? '',
      username: map['username'] ?? '',
      alamat: map['alamat'] ?? '',
      email: map['email'] ?? '',
      nomorHp: map['nomor_hp'] ?? '',
      nomorWhatsapp: map['nomor_whatsapp'] ?? '',
      akunGoogle: map['akun_google'] ?? false,
      notifikasiAktif: map['notifikasi_aktif'] ?? false,
      createdAt: (map['created_at'] as Timestamp).toDate(),
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }
} */