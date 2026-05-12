import '../models/wilayah_item.dart';

class WilayahService {
  Future<List<WilayahItem>> fetchProvinsi() async {
    return _provinsi;
  }

  Future<List<WilayahItem>> fetchKabupaten({
    required String provinceCode,
  }) async {
    return _kabupatenByProvinsi[provinceCode] ?? const [];
  }

  Future<List<WilayahItem>> fetchKecamatan({
    required String provinceCode,
    required String kabupatenCode,
  }) async {
    return _kecamatanByKabupaten['$provinceCode-$kabupatenCode'] ??
        _fallbackKecamatan;
  }

  static const List<WilayahItem> _provinsi = [
    WilayahItem(code: '11', name: 'Aceh'),
    WilayahItem(code: '12', name: 'Sumatera Utara'),
    WilayahItem(code: '13', name: 'Sumatera Barat'),
    WilayahItem(code: '14', name: 'Riau'),
    WilayahItem(code: '15', name: 'Jambi'),
    WilayahItem(code: '16', name: 'Sumatera Selatan'),
    WilayahItem(code: '17', name: 'Bengkulu'),
    WilayahItem(code: '18', name: 'Lampung'),
    WilayahItem(code: '19', name: 'Kepulauan Bangka Belitung'),
    WilayahItem(code: '21', name: 'Kepulauan Riau'),
    WilayahItem(code: '31', name: 'DKI Jakarta'),
    WilayahItem(code: '32', name: 'Jawa Barat'),
    WilayahItem(code: '33', name: 'Jawa Tengah'),
    WilayahItem(code: '34', name: 'DI Yogyakarta'),
    WilayahItem(code: '35', name: 'Jawa Timur'),
    WilayahItem(code: '36', name: 'Banten'),
    WilayahItem(code: '51', name: 'Bali'),
    WilayahItem(code: '52', name: 'Nusa Tenggara Barat'),
    WilayahItem(code: '53', name: 'Nusa Tenggara Timur'),
    WilayahItem(code: '61', name: 'Kalimantan Barat'),
    WilayahItem(code: '62', name: 'Kalimantan Tengah'),
    WilayahItem(code: '63', name: 'Kalimantan Selatan'),
    WilayahItem(code: '64', name: 'Kalimantan Timur'),
    WilayahItem(code: '65', name: 'Kalimantan Utara'),
    WilayahItem(code: '71', name: 'Sulawesi Utara'),
    WilayahItem(code: '72', name: 'Sulawesi Tengah'),
    WilayahItem(code: '73', name: 'Sulawesi Selatan'),
    WilayahItem(code: '74', name: 'Sulawesi Tenggara'),
    WilayahItem(code: '75', name: 'Gorontalo'),
    WilayahItem(code: '76', name: 'Sulawesi Barat'),
    WilayahItem(code: '81', name: 'Maluku'),
    WilayahItem(code: '82', name: 'Maluku Utara'),
    WilayahItem(code: '91', name: 'Papua Barat'),
    WilayahItem(code: '92', name: 'Papua Barat Daya'),
    WilayahItem(code: '93', name: 'Papua Selatan'),
    WilayahItem(code: '94', name: 'Papua'),
    WilayahItem(code: '95', name: 'Papua Tengah'),
    WilayahItem(code: '96', name: 'Papua Pegunungan'),
  ];

  static const Map<String, List<WilayahItem>> _kabupatenByProvinsi = {
    '11': [
      WilayahItem(code: '1101', name: 'Kabupaten Simeulue'),
      WilayahItem(code: '1108', name: 'Kabupaten Aceh Besar'),
      WilayahItem(code: '1171', name: 'Kota Banda Aceh'),
      WilayahItem(code: '1173', name: 'Kota Langsa'),
    ],
    '12': [
      WilayahItem(code: '1201', name: 'Kabupaten Nias'),
      WilayahItem(code: '1207', name: 'Kabupaten Deli Serdang'),
      WilayahItem(code: '1208', name: 'Kabupaten Langkat'),
      WilayahItem(code: '1210', name: 'Kabupaten Simalungun'),
      WilayahItem(code: '1218', name: 'Kabupaten Serdang Bedagai'),
      WilayahItem(code: '1220', name: 'Kabupaten Labuhanbatu'),
      WilayahItem(code: '1271', name: 'Kota Medan'),
      WilayahItem(code: '1272', name: 'Kota Pematangsiantar'),
      WilayahItem(code: '1275', name: 'Kota Binjai'),
    ],
    '13': [
      WilayahItem(code: '1302', name: 'Kabupaten Pesisir Selatan'),
      WilayahItem(code: '1306', name: 'Kabupaten Padang Pariaman'),
      WilayahItem(code: '1307', name: 'Kabupaten Agam'),
      WilayahItem(code: '1371', name: 'Kota Padang'),
      WilayahItem(code: '1375', name: 'Kota Bukittinggi'),
    ],
    '14': [
      WilayahItem(code: '1401', name: 'Kabupaten Kuantan Singingi'),
      WilayahItem(code: '1402', name: 'Kabupaten Indragiri Hulu'),
      WilayahItem(code: '1404', name: 'Kabupaten Pelalawan'),
      WilayahItem(code: '1406', name: 'Kabupaten Kampar'),
      WilayahItem(code: '1471', name: 'Kota Pekanbaru'),
      WilayahItem(code: '1473', name: 'Kota Dumai'),
    ],
    '15': [
      WilayahItem(code: '1501', name: 'Kabupaten Kerinci'),
      WilayahItem(code: '1505', name: 'Kabupaten Muaro Jambi'),
      WilayahItem(code: '1507', name: 'Kabupaten Tanjung Jabung Barat'),
      WilayahItem(code: '1571', name: 'Kota Jambi'),
    ],
    '16': [
      WilayahItem(code: '1602', name: 'Kabupaten Ogan Komering Ilir'),
      WilayahItem(code: '1603', name: 'Kabupaten Muara Enim'),
      WilayahItem(code: '1606', name: 'Kabupaten Musi Banyuasin'),
      WilayahItem(code: '1671', name: 'Kota Palembang'),
    ],
    '17': [
      WilayahItem(code: '1703', name: 'Kabupaten Bengkulu Utara'),
      WilayahItem(code: '1709', name: 'Kabupaten Bengkulu Tengah'),
      WilayahItem(code: '1771', name: 'Kota Bengkulu'),
    ],
    '18': [
      WilayahItem(code: '1801', name: 'Kabupaten Lampung Barat'),
      WilayahItem(code: '1804', name: 'Kabupaten Lampung Selatan'),
      WilayahItem(code: '1806', name: 'Kabupaten Lampung Tengah'),
      WilayahItem(code: '1871', name: 'Kota Bandar Lampung'),
    ],
    '19': [
      WilayahItem(code: '1901', name: 'Kabupaten Bangka'),
      WilayahItem(code: '1903', name: 'Kabupaten Bangka Barat'),
      WilayahItem(code: '1971', name: 'Kota Pangkal Pinang'),
    ],
    '21': [
      WilayahItem(code: '2101', name: 'Kabupaten Karimun'),
      WilayahItem(code: '2102', name: 'Kabupaten Bintan'),
      WilayahItem(code: '2171', name: 'Kota Batam'),
      WilayahItem(code: '2172', name: 'Kota Tanjung Pinang'),
    ],
    '31': [
      WilayahItem(code: '3171', name: 'Kota Jakarta Selatan'),
      WilayahItem(code: '3172', name: 'Kota Jakarta Timur'),
      WilayahItem(code: '3173', name: 'Kota Jakarta Pusat'),
      WilayahItem(code: '3174', name: 'Kota Jakarta Barat'),
      WilayahItem(code: '3175', name: 'Kota Jakarta Utara'),
    ],
    '32': [
      WilayahItem(code: '3201', name: 'Kabupaten Bogor'),
      WilayahItem(code: '3204', name: 'Kabupaten Bandung'),
      WilayahItem(code: '3273', name: 'Kota Bandung'),
      WilayahItem(code: '3275', name: 'Kota Bekasi'),
      WilayahItem(code: '3276', name: 'Kota Depok'),
    ],
    '33': [
      WilayahItem(code: '3371', name: 'Kota Magelang'),
      WilayahItem(code: '3372', name: 'Kota Surakarta'),
      WilayahItem(code: '3374', name: 'Kota Semarang'),
      WilayahItem(code: '3302', name: 'Kabupaten Banyumas'),
      WilayahItem(code: '3322', name: 'Kabupaten Semarang'),
    ],
    '34': [
      WilayahItem(code: '3401', name: 'Kabupaten Kulon Progo'),
      WilayahItem(code: '3402', name: 'Kabupaten Bantul'),
      WilayahItem(code: '3403', name: 'Kabupaten Gunungkidul'),
      WilayahItem(code: '3404', name: 'Kabupaten Sleman'),
      WilayahItem(code: '3471', name: 'Kota Yogyakarta'),
    ],
    '35': [
      WilayahItem(code: '3507', name: 'Kabupaten Malang'),
      WilayahItem(code: '3515', name: 'Kabupaten Sidoarjo'),
      WilayahItem(code: '3573', name: 'Kota Malang'),
      WilayahItem(code: '3578', name: 'Kota Surabaya'),
    ],
    '36': [
      WilayahItem(code: '3603', name: 'Kabupaten Tangerang'),
      WilayahItem(code: '3671', name: 'Kota Tangerang'),
      WilayahItem(code: '3673', name: 'Kota Serang'),
      WilayahItem(code: '3674', name: 'Kota Tangerang Selatan'),
    ],
    '51': [
      WilayahItem(code: '5103', name: 'Kabupaten Badung'),
      WilayahItem(code: '5104', name: 'Kabupaten Gianyar'),
      WilayahItem(code: '5171', name: 'Kota Denpasar'),
    ],
    '52': [
      WilayahItem(code: '5201', name: 'Kabupaten Lombok Barat'),
      WilayahItem(code: '5203', name: 'Kabupaten Lombok Timur'),
      WilayahItem(code: '5271', name: 'Kota Mataram'),
    ],
    '53': [
      WilayahItem(code: '5303', name: 'Kabupaten Kupang'),
      WilayahItem(code: '5316', name: 'Kabupaten Manggarai Barat'),
      WilayahItem(code: '5371', name: 'Kota Kupang'),
    ],
    '61': [
      WilayahItem(code: '6102', name: 'Kabupaten Mempawah'),
      WilayahItem(code: '6107', name: 'Kabupaten Sintang'),
      WilayahItem(code: '6171', name: 'Kota Pontianak'),
    ],
    '62': [
      WilayahItem(code: '6201', name: 'Kabupaten Kotawaringin Barat'),
      WilayahItem(code: '6202', name: 'Kabupaten Kotawaringin Timur'),
      WilayahItem(code: '6271', name: 'Kota Palangka Raya'),
    ],
    '63': [
      WilayahItem(code: '6301', name: 'Kabupaten Tanah Laut'),
      WilayahItem(code: '6303', name: 'Kabupaten Banjar'),
      WilayahItem(code: '6371', name: 'Kota Banjarmasin'),
    ],
    '64': [
      WilayahItem(code: '6402', name: 'Kabupaten Kutai Kartanegara'),
      WilayahItem(code: '6471', name: 'Kota Balikpapan'),
      WilayahItem(code: '6472', name: 'Kota Samarinda'),
    ],
    '65': [
      WilayahItem(code: '6501', name: 'Kabupaten Bulungan'),
      WilayahItem(code: '6502', name: 'Kabupaten Malinau'),
      WilayahItem(code: '6571', name: 'Kota Tarakan'),
    ],
    '71': [
      WilayahItem(code: '7102', name: 'Kabupaten Minahasa'),
      WilayahItem(code: '7171', name: 'Kota Manado'),
      WilayahItem(code: '7172', name: 'Kota Bitung'),
    ],
    '72': [
      WilayahItem(code: '7201', name: 'Kabupaten Banggai'),
      WilayahItem(code: '7203', name: 'Kabupaten Donggala'),
      WilayahItem(code: '7271', name: 'Kota Palu'),
    ],
    '73': [
      WilayahItem(code: '7306', name: 'Kabupaten Gowa'),
      WilayahItem(code: '7371', name: 'Kota Makassar'),
      WilayahItem(code: '7372', name: 'Kota Parepare'),
    ],
    '74': [
      WilayahItem(code: '7405', name: 'Kabupaten Konawe Selatan'),
      WilayahItem(code: '7471', name: 'Kota Kendari'),
      WilayahItem(code: '7472', name: 'Kota Baubau'),
    ],
    '75': [
      WilayahItem(code: '7502', name: 'Kabupaten Gorontalo'),
      WilayahItem(code: '7571', name: 'Kota Gorontalo'),
    ],
    '76': [
      WilayahItem(code: '7601', name: 'Kabupaten Majene'),
      WilayahItem(code: '7602', name: 'Kabupaten Polewali Mandar'),
      WilayahItem(code: '7605', name: 'Kabupaten Mamuju'),
    ],
    '81': [
      WilayahItem(code: '8101', name: 'Kabupaten Maluku Tenggara Barat'),
      WilayahItem(code: '8171', name: 'Kota Ambon'),
      WilayahItem(code: '8172', name: 'Kota Tual'),
    ],
    '82': [
      WilayahItem(code: '8201', name: 'Kabupaten Halmahera Barat'),
      WilayahItem(code: '8271', name: 'Kota Ternate'),
      WilayahItem(code: '8272', name: 'Kota Tidore Kepulauan'),
    ],
    '91': [
      WilayahItem(code: '9105', name: 'Kabupaten Manokwari'),
      WilayahItem(code: '9112', name: 'Kabupaten Pegunungan Arfak'),
    ],
    '92': [
      WilayahItem(code: '9201', name: 'Kabupaten Sorong'),
      WilayahItem(code: '9271', name: 'Kota Sorong'),
    ],
    '93': [
      WilayahItem(code: '9301', name: 'Kabupaten Merauke'),
      WilayahItem(code: '9302', name: 'Kabupaten Boven Digoel'),
    ],
    '94': [
      WilayahItem(code: '9403', name: 'Kabupaten Jayapura'),
      WilayahItem(code: '9471', name: 'Kota Jayapura'),
    ],
    '95': [
      WilayahItem(code: '9501', name: 'Kabupaten Nabire'),
      WilayahItem(code: '9508', name: 'Kabupaten Mimika'),
    ],
    '96': [
      WilayahItem(code: '9601', name: 'Kabupaten Jayawijaya'),
      WilayahItem(code: '9604', name: 'Kabupaten Tolikara'),
    ],
  };

  static const Map<String, List<WilayahItem>> _kecamatanByKabupaten = {
    '12-1271': [
      WilayahItem(code: '127101', name: 'Medan Kota'),
      WilayahItem(code: '127102', name: 'Medan Area'),
      WilayahItem(code: '127103', name: 'Medan Denai'),
      WilayahItem(code: '127104', name: 'Medan Maimun'),
      WilayahItem(code: '127105', name: 'Medan Johor'),
      WilayahItem(code: '127106', name: 'Medan Baru'),
      WilayahItem(code: '127107', name: 'Medan Selayang'),
      WilayahItem(code: '127108', name: 'Medan Sunggal'),
      WilayahItem(code: '127109', name: 'Medan Petisah'),
      WilayahItem(code: '127110', name: 'Medan Barat'),
      WilayahItem(code: '127111', name: 'Medan Timur'),
      WilayahItem(code: '127112', name: 'Medan Perjuangan'),
      WilayahItem(code: '127113', name: 'Medan Tembung'),
      WilayahItem(code: '127114', name: 'Medan Deli'),
      WilayahItem(code: '127115', name: 'Medan Labuhan'),
      WilayahItem(code: '127116', name: 'Medan Marelan'),
      WilayahItem(code: '127117', name: 'Medan Belawan'),
    ],
    '12-1207': [
      WilayahItem(code: '120701', name: 'Lubuk Pakam'),
      WilayahItem(code: '120702', name: 'Tanjung Morawa'),
      WilayahItem(code: '120703', name: 'Percut Sei Tuan'),
      WilayahItem(code: '120704', name: 'Sunggal'),
      WilayahItem(code: '120705', name: 'Pancur Batu'),
      WilayahItem(code: '120706', name: 'Deli Tua'),
    ],
    '12-1208': [
      WilayahItem(code: '120801', name: 'Stabat'),
      WilayahItem(code: '120802', name: 'Binjai'),
      WilayahItem(code: '120803', name: 'Tanjung Pura'),
      WilayahItem(code: '120804', name: 'Pangkalan Susu'),
    ],
    '12-1220': [
      WilayahItem(code: '122001', name: 'Rantau Utara'),
      WilayahItem(code: '122002', name: 'Rantau Selatan'),
      WilayahItem(code: '122003', name: 'Bilah Barat'),
      WilayahItem(code: '122004', name: 'Bilah Hulu'),
    ],
    '11-1171': [
      WilayahItem(code: '117101', name: 'Baiturrahman'),
      WilayahItem(code: '117102', name: 'Kuta Alam'),
      WilayahItem(code: '117103', name: 'Syiah Kuala'),
      WilayahItem(code: '117104', name: 'Lueng Bata'),
    ],
    '13-1371': [
      WilayahItem(code: '137101', name: 'Padang Barat'),
      WilayahItem(code: '137102', name: 'Padang Timur'),
      WilayahItem(code: '137103', name: 'Padang Utara'),
      WilayahItem(code: '137104', name: 'Koto Tangah'),
    ],
    '14-1471': [
      WilayahItem(code: '147101', name: 'Sukajadi'),
      WilayahItem(code: '147102', name: 'Pekanbaru Kota'),
      WilayahItem(code: '147103', name: 'Rumbai'),
      WilayahItem(code: '147104', name: 'Tampan'),
    ],
    '31-3171': [
      WilayahItem(code: '317101', name: 'Tebet'),
      WilayahItem(code: '317102', name: 'Setiabudi'),
      WilayahItem(code: '317103', name: 'Mampang Prapatan'),
      WilayahItem(code: '317104', name: 'Kebayoran Baru'),
    ],
    '32-3273': [
      WilayahItem(code: '327301', name: 'Sukasari'),
      WilayahItem(code: '327302', name: 'Coblong'),
      WilayahItem(code: '327303', name: 'Bandung Wetan'),
      WilayahItem(code: '327304', name: 'Cicendo'),
    ],
    '33-3374': [
      WilayahItem(code: '337401', name: 'Semarang Tengah'),
      WilayahItem(code: '337402', name: 'Semarang Utara'),
      WilayahItem(code: '337403', name: 'Semarang Timur'),
      WilayahItem(code: '337404', name: 'Tembalang'),
    ],
    '34-3471': [
      WilayahItem(code: '347101', name: 'Mantrijeron'),
      WilayahItem(code: '347102', name: 'Kraton'),
      WilayahItem(code: '347103', name: 'Mergangsan'),
      WilayahItem(code: '347104', name: 'Umbulharjo'),
    ],
    '35-3578': [
      WilayahItem(code: '357801', name: 'Tegalsari'),
      WilayahItem(code: '357802', name: 'Genteng'),
      WilayahItem(code: '357803', name: 'Gubeng'),
      WilayahItem(code: '357804', name: 'Wonokromo'),
    ],
    '51-5171': [
      WilayahItem(code: '517101', name: 'Denpasar Selatan'),
      WilayahItem(code: '517102', name: 'Denpasar Timur'),
      WilayahItem(code: '517103', name: 'Denpasar Barat'),
      WilayahItem(code: '517104', name: 'Denpasar Utara'),
    ],
  };

  static const List<WilayahItem> _fallbackKecamatan = [
    WilayahItem(code: '000001', name: 'Kecamatan Utama'),
    WilayahItem(code: '000002', name: 'Kecamatan Tengah'),
    WilayahItem(code: '000003', name: 'Kecamatan Selatan'),
  ];
}
