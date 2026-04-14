class KebunModel {
  final String id;
  final String namaKebun;
  final int totalPohon;
  final DateTime tanggalAnalisis;
  final DateTime tanggalPengambilanData;

  const KebunModel({
    required this.id,
    required this.namaKebun,
    required this.totalPohon,
    required this.tanggalAnalisis,
    required this.tanggalPengambilanData,
  });
}