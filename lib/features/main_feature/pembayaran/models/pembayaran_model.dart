enum PembayaranStatus {
  proses,
  selesai,
  dibatalkan,
}

class PembayaranModel {
  final String id;
  final String namaProjek;
  final DateTime tanggal;
  final int jumlahBaris;
  final PembayaranStatus status;

  final String kebun;
  final String lokasi;
  final int hargaPerSatuanPohon;
  final int totalPohon;
  final double perkiraanLuasHa;
  final int subTotal;
  final String orderId;

  const PembayaranModel({
    required this.id,
    required this.namaProjek,
    required this.tanggal,
    required this.jumlahBaris,
    required this.status,
    required this.kebun,
    required this.lokasi,
    required this.hargaPerSatuanPohon,
    required this.totalPohon,
    required this.perkiraanLuasHa,
    required this.subTotal,
    required this.orderId,
  });

  PembayaranModel copyWith({
    String? id,
    String? namaProjek,
    DateTime? tanggal,
    int? jumlahBaris,
    PembayaranStatus? status,
    String? kebun,
    String? lokasi,
    int? hargaPerSatuanPohon,
    int? totalPohon,
    double? perkiraanLuasHa,
    int? subTotal,
    String? orderId,
  }) {
    return PembayaranModel(
      id: id ?? this.id,
      namaProjek: namaProjek ?? this.namaProjek,
      tanggal: tanggal ?? this.tanggal,
      jumlahBaris: jumlahBaris ?? this.jumlahBaris,
      status: status ?? this.status,
      kebun: kebun ?? this.kebun,
      lokasi: lokasi ?? this.lokasi,
      hargaPerSatuanPohon: hargaPerSatuanPohon ?? this.hargaPerSatuanPohon,
      totalPohon: totalPohon ?? this.totalPohon,
      perkiraanLuasHa: perkiraanLuasHa ?? this.perkiraanLuasHa,
      subTotal: subTotal ?? this.subTotal,
      orderId: orderId ?? this.orderId,
    );
  }

  static String statusLabel(PembayaranStatus status) {
    switch (status) {
      case PembayaranStatus.proses:
        return 'Proses Pembayaran';
      case PembayaranStatus.selesai:
        return 'Pembayaran Selesai';
      case PembayaranStatus.dibatalkan:
        return 'Pembayaran Dibatalkan';
    }
  }
}