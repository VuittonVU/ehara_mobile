class RiwayatItemModel {
  final int idAnalisis;
  final String kodeAnalisis;
  final DateTime tanggalAnalisis;

  final String namaProyek;
  final String namaPerusahaan;
  final String namaCustomer;
  final String namaKebun;

  final String alamatDetail;
  final String kecamatan;
  final String kabupatenKota;
  final String provinsi;

  final String? nomorSertifikat;
  final String statusSertifikat;
  final int totalDataTampil;

  const RiwayatItemModel({
    required this.idAnalisis,
    required this.kodeAnalisis,
    required this.tanggalAnalisis,
    required this.namaProyek,
    required this.namaPerusahaan,
    required this.namaCustomer,
    required this.namaKebun,
    required this.alamatDetail,
    required this.kecamatan,
    required this.kabupatenKota,
    required this.provinsi,
    required this.nomorSertifikat,
    required this.statusSertifikat,
    required this.totalDataTampil,
  });

  String get alamatLengkap {
    final parts = [
      alamatDetail,
      kecamatan,
      kabupatenKota,
      provinsi,
    ].where((e) => e.trim().isNotEmpty).toList();

    return parts.join(', ');
  }

  bool get isSertifikatTerbit =>
      statusSertifikat.toLowerCase().trim() == 'sudah terbit';

  factory RiwayatItemModel.fromMap(Map<String, dynamic> map) {
    return RiwayatItemModel(
      idAnalisis: map['id_analisis'] as int,
      kodeAnalisis: map['kode_analisis'] as String? ?? '',
      tanggalAnalisis: DateTime.parse(map['tanggal_analisis'] as String),
      namaProyek: map['nama_proyek'] as String? ?? '',
      namaPerusahaan: map['nama_perusahaan'] as String? ?? '',
      namaCustomer: map['nama_customer'] as String? ?? '',
      namaKebun: map['nama_kebun'] as String? ?? '',
      alamatDetail: map['alamat_detail'] as String? ?? '',
      kecamatan: map['kecamatan'] as String? ?? '',
      kabupatenKota: map['kabupaten_kota'] as String? ?? '',
      provinsi: map['provinsi'] as String? ?? '',
      nomorSertifikat: map['nomor_sertifikat'] as String?,
      statusSertifikat: map['status_sertifikat'] as String? ?? 'Belum Terbit',
      totalDataTampil: map['total_data_tampil'] as int? ?? 3,
    );
  }
}