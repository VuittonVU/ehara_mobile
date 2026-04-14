import '../models/pembayaran_model.dart';

class PembayaranService {
  Future<List<PembayaranModel>> getPembayaranList() async {
    await Future.delayed(const Duration(milliseconds: 350));

    return [
      PembayaranModel(
        id: '1',
        namaProjek: 'Projek Nusantara',
        tanggal: DateTime(2026, 3, 9),
        jumlahBaris: 286,
        status: PembayaranStatus.proses,
        kebun: 'Kwala Sawit',
        lokasi:
        'Jalan Kwala Sawit, Kwala Musam, Kecamatan Batang Serangan, Kabupaten Langkat, Sumatera Utara',
        hargaPerSatuanPohon: 108,
        totalPohon: 286,
        perkiraanLuasHa: 2.00,
        subTotal: 30800,
        orderId: '#e-Hara-605183',
      ),
      PembayaranModel(
        id: '2',
        namaProjek: 'Projek Nusantara',
        tanggal: DateTime(2026, 3, 9),
        jumlahBaris: 286,
        status: PembayaranStatus.selesai,
        kebun: 'Kwala Sawit',
        lokasi:
        'Jalan Kwala Sawit, Kwala Musam, Kecamatan Batang Serangan, Kabupaten Langkat, Sumatera Utara',
        hargaPerSatuanPohon: 108,
        totalPohon: 286,
        perkiraanLuasHa: 2.00,
        subTotal: 30800,
        orderId: '#e-Hara-605184',
      ),
      PembayaranModel(
        id: '3',
        namaProjek: 'Projek Nusantara',
        tanggal: DateTime(2026, 3, 9),
        jumlahBaris: 286,
        status: PembayaranStatus.dibatalkan,
        kebun: 'Kwala Sawit',
        lokasi:
        'Jalan Kwala Sawit, Kwala Musam, Kecamatan Batang Serangan, Kabupaten Langkat, Sumatera Utara',
        hargaPerSatuanPohon: 108,
        totalPohon: 286,
        perkiraanLuasHa: 2.00,
        subTotal: 30800,
        orderId: '#e-Hara-605185',
      ),
    ];
  }
}