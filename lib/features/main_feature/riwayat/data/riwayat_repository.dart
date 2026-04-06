import 'package:flutter/foundation.dart';
import '../models/riwayat_item_model.dart';

class RiwayatRepository {
  Future<List<RiwayatItemModel>> getRiwayatAnalisis() async {
    await Future.delayed(const Duration(milliseconds: 350));

    final List<Map<String, dynamic>> response = [
      {
        'id_analisis': 1,
        'kode_analisis': 'ANL-0001',
        'tanggal_analisis': '2026-03-10',
        'nama_proyek': 'Projek Nusantara',
        'nama_perusahaan': 'Perkebunan Nusantara 2',
        'nama_customer': 'Budi Wijaya',
        'nama_kebun': 'Kwala Sawit',
        'alamat_detail': 'Jalan Kwala Sawit',
        'kecamatan': 'Batang Serangan',
        'kabupaten_kota': 'Langkat',
        'provinsi': 'Sumatera Utara',
        'nomor_sertifikat': 'SRT-001',
        'status_sertifikat': 'Sudah Terbit',
        'total_data_tampil': 3,
      },
      {
        'id_analisis': 2,
        'kode_analisis': 'ANL-0002',
        'tanggal_analisis': '2026-02-20',
        'nama_proyek': 'Projek Sawit Jaya',
        'nama_perusahaan': 'PT Sawit Makmur',
        'nama_customer': 'Andi Saputra',
        'nama_kebun': 'Kebun A',
        'alamat_detail': 'Jalan Sawit Jaya',
        'kecamatan': 'Stabat',
        'kabupaten_kota': 'Langkat',
        'provinsi': 'Sumatera Utara',
        'nomor_sertifikat': null,
        'status_sertifikat': 'Belum Terbit',
        'total_data_tampil': 3,
      },
      {
        'id_analisis': 3,
        'kode_analisis': 'ANL-0003',
        'tanggal_analisis': '2026-01-15',
        'nama_proyek': 'Green Palm Project',
        'nama_perusahaan': 'PT Green Palm',
        'nama_customer': 'Siti Rahma',
        'nama_kebun': 'Palm Estate 1',
        'alamat_detail': 'Jl. Hijau Lestari',
        'kecamatan': 'Binjai',
        'kabupaten_kota': 'Binjai',
        'provinsi': 'Sumatera Utara',
        'nomor_sertifikat': 'SRT-002',
        'status_sertifikat': 'Sudah Terbit',
        'total_data_tampil': 3,
      },
      {
        'id_analisis': 4,
        'kode_analisis': 'ANL-0004',
        'tanggal_analisis': '2025-12-01',
        'nama_proyek': 'Palm Future',
        'nama_perusahaan': 'Future Agro',
        'nama_customer': 'Joko Susilo',
        'nama_kebun': 'Estate B',
        'alamat_detail': 'Jl. Masa Depan',
        'kecamatan': 'Medan Helvetia',
        'kabupaten_kota': 'Medan',
        'provinsi': 'Sumatera Utara',
        'nomor_sertifikat': null,
        'status_sertifikat': 'Belum Terbit',
        'total_data_tampil': 3,
      },
      {
        'id_analisis': 5,
        'kode_analisis': 'ANL-0005',
        'tanggal_analisis': '2026-03-05',
        'nama_proyek': 'Agro Nusantara',
        'nama_perusahaan': 'PT Agro Nusantara',
        'nama_customer': 'Rina Kartika',
        'nama_kebun': 'Blok C',
        'alamat_detail': 'Jl. Nusantara',
        'kecamatan': 'Lubuk Pakam',
        'kabupaten_kota': 'Deli Serdang',
        'provinsi': 'Sumatera Utara',
        'nomor_sertifikat': 'SRT-003',
        'status_sertifikat': 'Sudah Terbit',
        'total_data_tampil': 3,
      },
    ];

    return response.map(RiwayatItemModel.fromMap).toList();
  }

  Future<List<RiwayatItemModel>> searchRiwayat(String keyword) async {
    final data = await getRiwayatAnalisis();

    if (keyword.trim().isEmpty) return data;

    final lower = keyword.toLowerCase();

    return data.where((item) {
      return item.namaProyek.toLowerCase().contains(lower) ||
          item.namaPerusahaan.toLowerCase().contains(lower) ||
          item.namaCustomer.toLowerCase().contains(lower) ||
          item.namaKebun.toLowerCase().contains(lower) ||
          item.alamatLengkap.toLowerCase().contains(lower) ||
          item.kodeAnalisis.toLowerCase().contains(lower) ||
          (item.nomorSertifikat?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }

  @visibleForTesting
  List<RiwayatItemModel> limitData(List<RiwayatItemModel> data, int limit) {
    if (limit >= data.length) return data;
    return data.take(limit).toList();
  }
}