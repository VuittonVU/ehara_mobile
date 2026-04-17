import '../models/wilayah_item.dart';

class WilayahService {
  Future<List<WilayahItem>> fetchProvinsi() async {
    return _provinsi;
  }

  Future<List<WilayahItem>> fetchKabupaten({
    required String provinceCode,
  }) async {
    return _kabupatenByProvinsi[provinceCode] ?? _defaultKabupaten;
  }

  Future<List<WilayahItem>> fetchKecamatan({
    required String provinceCode,
    required String kabupatenCode,
  }) async {
    return _kecamatanByKabupaten['$provinceCode-$kabupatenCode'] ??
        _defaultKecamatan;
  }

  static const List<WilayahItem> _provinsi = [
    WilayahItem(code: '12', name: 'Sumatera Utara'),
    WilayahItem(code: '11', name: 'Aceh'),
    WilayahItem(code: '13', name: 'Sumatera Barat'),
  ];

  static const Map<String, List<WilayahItem>> _kabupatenByProvinsi = {
    '12': [
      WilayahItem(code: '1271', name: 'Kota Medan'),
      WilayahItem(code: '1207', name: 'Deli Serdang'),
      WilayahItem(code: '1220', name: 'Labuhanbatu'),
    ],
    '11': [
      WilayahItem(code: '1101', name: 'Kabupaten Simeulue'),
      WilayahItem(code: '1171', name: 'Kota Banda Aceh'),
    ],
    '13': [
      WilayahItem(code: '1371', name: 'Kota Padang'),
      WilayahItem(code: '1307', name: 'Kabupaten Agam'),
    ],
  };

  static const Map<String, List<WilayahItem>> _kecamatanByKabupaten = {
    '12-1271': [
      WilayahItem(code: '1271010', name: 'Medan Kota'),
      WilayahItem(code: '1271020', name: 'Medan Area'),
      WilayahItem(code: '1271030', name: 'Medan Denai'),
    ],
    '12-1207': [
      WilayahItem(code: '1207010', name: 'Lubuk Pakam'),
      WilayahItem(code: '1207020', name: 'Tanjung Morawa'),
    ],
    '12-1220': [
      WilayahItem(code: '1220010', name: 'Rantau Selatan'),
      WilayahItem(code: '1220020', name: 'Rantau Utara'),
    ],
    '11-1171': [
      WilayahItem(code: '1171010', name: 'Baiturrahman'),
      WilayahItem(code: '1171020', name: 'Kuta Alam'),
    ],
    '13-1371': [
      WilayahItem(code: '1371010', name: 'Padang Barat'),
      WilayahItem(code: '1371020', name: 'Padang Timur'),
    ],
  };

  static const List<WilayahItem> _defaultKabupaten = [
    WilayahItem(code: '0001', name: 'Kabupaten Contoh 1'),
    WilayahItem(code: '0002', name: 'Kabupaten Contoh 2'),
  ];

  static const List<WilayahItem> _defaultKecamatan = [
    WilayahItem(code: '000101', name: 'Kecamatan Contoh 1'),
    WilayahItem(code: '000102', name: 'Kecamatan Contoh 2'),
  ];
}