import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

import '../models/wilayah_item.dart';

class TambahFormState {
  final bool initialized;
  final bool isLoadingProvinsi;
  final bool isLoadingKabupaten;
  final bool isLoadingKecamatan;
  final bool isSavingDraft;
  final bool hasDraft;
  final String? errorMessage;

  final String fileName;
  final Uint8List? temporaryImageBytes;
  final String temporaryImageName;

  final String namaProjek;
  final String namaPerusahaan;
  final String namaKebun;
  final String detailLokasi;
  final String tanggalPengambilan;
  final String tanggalAnalisis;
  final String sensor;
  final String ganodermaStep1;

  final List<WilayahItem> provinsiList;
  final List<WilayahItem> kabupatenList;
  final List<WilayahItem> kecamatanList;

  final WilayahItem? selectedProvinsi;
  final WilayahItem? selectedKabupaten;
  final WilayahItem? selectedKecamatan;

  final String tahunTanam;
  final String nomorKcd;
  final String blok;
  final String luasHa;
  final String jumlahPohonHa;
  final String protas;
  final String proyeksiProtasStep2;
  final String ganodermaStep2;
  final String statusHaraTanahStep2;

  final String nilaiNStep2;
  final String nilaiPStep2;
  final String nilaiKStep2;
  final String nilaiCaStep2;
  final String nilaiMgStep2;

  final double? latitude;
  final double? longitude;

  final String idTitik;
  final String bandRed;
  final String bandGreen;
  final String bandNir;
  final String proyeksiProtasStep3;
  final String ganodermaStep3;
  final String statusHaraTanahStep3;

  final String nilaiNStep3;
  final String nilaiPStep3;
  final String nilaiKStep3;
  final String nilaiCaStep3;
  final String nilaiMgStep3;

  const TambahFormState({
    required this.initialized,
    required this.isLoadingProvinsi,
    required this.isLoadingKabupaten,
    required this.isLoadingKecamatan,
    required this.isSavingDraft,
    required this.hasDraft,
    required this.errorMessage,
    required this.fileName,
    required this.temporaryImageBytes,
    required this.temporaryImageName,
    required this.namaProjek,
    required this.namaPerusahaan,
    required this.namaKebun,
    required this.detailLokasi,
    required this.tanggalPengambilan,
    required this.tanggalAnalisis,
    required this.sensor,
    required this.ganodermaStep1,
    required this.provinsiList,
    required this.kabupatenList,
    required this.kecamatanList,
    required this.selectedProvinsi,
    required this.selectedKabupaten,
    required this.selectedKecamatan,
    required this.tahunTanam,
    required this.nomorKcd,
    required this.blok,
    required this.luasHa,
    required this.jumlahPohonHa,
    required this.protas,
    required this.proyeksiProtasStep2,
    required this.ganodermaStep2,
    required this.statusHaraTanahStep2,
    required this.nilaiNStep2,
    required this.nilaiPStep2,
    required this.nilaiKStep2,
    required this.nilaiCaStep2,
    required this.nilaiMgStep2,
    required this.latitude,
    required this.longitude,
    required this.idTitik,
    required this.bandRed,
    required this.bandGreen,
    required this.bandNir,
    required this.proyeksiProtasStep3,
    required this.ganodermaStep3,
    required this.statusHaraTanahStep3,
    required this.nilaiNStep3,
    required this.nilaiPStep3,
    required this.nilaiKStep3,
    required this.nilaiCaStep3,
    required this.nilaiMgStep3,
  });

  factory TambahFormState.initial() {
    return const TambahFormState(
      initialized: false,
      isLoadingProvinsi: false,
      isLoadingKabupaten: false,
      isLoadingKecamatan: false,
      isSavingDraft: false,
      hasDraft: false,
      errorMessage: null,
      fileName: '',
      temporaryImageBytes: null,
      temporaryImageName: '',
      namaProjek: '',
      namaPerusahaan: '',
      namaKebun: '',
      detailLokasi: '',
      tanggalPengambilan: '',
      tanggalAnalisis: '',
      sensor: '',
      ganodermaStep1: '',
      provinsiList: [],
      kabupatenList: [],
      kecamatanList: [],
      selectedProvinsi: null,
      selectedKabupaten: null,
      selectedKecamatan: null,
      tahunTanam: '',
      nomorKcd: '',
      blok: '',
      luasHa: '',
      jumlahPohonHa: '',
      protas: '',
      proyeksiProtasStep2: '',
      ganodermaStep2: 'Ya',
      statusHaraTanahStep2: 'Ada Nilai Hara Tanah',
      nilaiNStep2: '',
      nilaiPStep2: '',
      nilaiKStep2: '',
      nilaiCaStep2: '',
      nilaiMgStep2: '',
      latitude: null,
      longitude: null,
      idTitik: '',
      bandRed: '',
      bandGreen: '',
      bandNir: '',
      proyeksiProtasStep3: '',
      ganodermaStep3: '',
      statusHaraTanahStep3: '',
      nilaiNStep3: '',
      nilaiPStep3: '',
      nilaiKStep3: '',
      nilaiCaStep3: '',
      nilaiMgStep3: '',
    );
  }

  bool get showSoilFieldsStep2 =>
      statusHaraTanahStep2 == 'Ada Nilai Hara Tanah';

  bool get showSoilFieldsStep3 =>
      statusHaraTanahStep3 == 'Ada Nilai Hara Tanah';

  LatLng? get selectedLatLng {
    if (latitude == null || longitude == null) return null;
    return LatLng(latitude!, longitude!);
  }

  TambahFormState copyWith({
    bool? initialized,
    bool? isLoadingProvinsi,
    bool? isLoadingKabupaten,
    bool? isLoadingKecamatan,
    bool? isSavingDraft,
    bool? hasDraft,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? fileName,
    Uint8List? temporaryImageBytes,
    bool clearTemporaryImage = false,
    String? temporaryImageName,
    String? namaProjek,
    String? namaPerusahaan,
    String? namaKebun,
    String? detailLokasi,
    String? tanggalPengambilan,
    String? tanggalAnalisis,
    String? sensor,
    String? ganodermaStep1,
    List<WilayahItem>? provinsiList,
    List<WilayahItem>? kabupatenList,
    List<WilayahItem>? kecamatanList,
    WilayahItem? selectedProvinsi,
    bool clearSelectedProvinsi = false,
    WilayahItem? selectedKabupaten,
    bool clearSelectedKabupaten = false,
    WilayahItem? selectedKecamatan,
    bool clearSelectedKecamatan = false,
    String? tahunTanam,
    String? nomorKcd,
    String? blok,
    String? luasHa,
    String? jumlahPohonHa,
    String? protas,
    String? proyeksiProtasStep2,
    String? ganodermaStep2,
    String? statusHaraTanahStep2,
    String? nilaiNStep2,
    String? nilaiPStep2,
    String? nilaiKStep2,
    String? nilaiCaStep2,
    String? nilaiMgStep2,
    double? latitude,
    bool clearLatitude = false,
    double? longitude,
    bool clearLongitude = false,
    String? idTitik,
    String? bandRed,
    String? bandGreen,
    String? bandNir,
    String? proyeksiProtasStep3,
    String? ganodermaStep3,
    String? statusHaraTanahStep3,
    String? nilaiNStep3,
    String? nilaiPStep3,
    String? nilaiKStep3,
    String? nilaiCaStep3,
    String? nilaiMgStep3,
  }) {
    return TambahFormState(
      initialized: initialized ?? this.initialized,
      isLoadingProvinsi: isLoadingProvinsi ?? this.isLoadingProvinsi,
      isLoadingKabupaten: isLoadingKabupaten ?? this.isLoadingKabupaten,
      isLoadingKecamatan: isLoadingKecamatan ?? this.isLoadingKecamatan,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      hasDraft: hasDraft ?? this.hasDraft,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      fileName: fileName ?? this.fileName,
      temporaryImageBytes: clearTemporaryImage
          ? null
          : (temporaryImageBytes ?? this.temporaryImageBytes),
      temporaryImageName: clearTemporaryImage
          ? ''
          : (temporaryImageName ?? this.temporaryImageName),
      namaProjek: namaProjek ?? this.namaProjek,
      namaPerusahaan: namaPerusahaan ?? this.namaPerusahaan,
      namaKebun: namaKebun ?? this.namaKebun,
      detailLokasi: detailLokasi ?? this.detailLokasi,
      tanggalPengambilan: tanggalPengambilan ?? this.tanggalPengambilan,
      tanggalAnalisis: tanggalAnalisis ?? this.tanggalAnalisis,
      sensor: sensor ?? this.sensor,
      ganodermaStep1: ganodermaStep1 ?? this.ganodermaStep1,
      provinsiList: provinsiList ?? this.provinsiList,
      kabupatenList: kabupatenList ?? this.kabupatenList,
      kecamatanList: kecamatanList ?? this.kecamatanList,
      selectedProvinsi: clearSelectedProvinsi
          ? null
          : (selectedProvinsi ?? this.selectedProvinsi),
      selectedKabupaten: clearSelectedKabupaten
          ? null
          : (selectedKabupaten ?? this.selectedKabupaten),
      selectedKecamatan: clearSelectedKecamatan
          ? null
          : (selectedKecamatan ?? this.selectedKecamatan),
      tahunTanam: tahunTanam ?? this.tahunTanam,
      nomorKcd: nomorKcd ?? this.nomorKcd,
      blok: blok ?? this.blok,
      luasHa: luasHa ?? this.luasHa,
      jumlahPohonHa: jumlahPohonHa ?? this.jumlahPohonHa,
      protas: protas ?? this.protas,
      proyeksiProtasStep2:
      proyeksiProtasStep2 ?? this.proyeksiProtasStep2,
      ganodermaStep2: ganodermaStep2 ?? this.ganodermaStep2,
      statusHaraTanahStep2:
      statusHaraTanahStep2 ?? this.statusHaraTanahStep2,
      nilaiNStep2: nilaiNStep2 ?? this.nilaiNStep2,
      nilaiPStep2: nilaiPStep2 ?? this.nilaiPStep2,
      nilaiKStep2: nilaiKStep2 ?? this.nilaiKStep2,
      nilaiCaStep2: nilaiCaStep2 ?? this.nilaiCaStep2,
      nilaiMgStep2: nilaiMgStep2 ?? this.nilaiMgStep2,
      latitude: clearLatitude ? null : (latitude ?? this.latitude),
      longitude: clearLongitude ? null : (longitude ?? this.longitude),
      idTitik: idTitik ?? this.idTitik,
      bandRed: bandRed ?? this.bandRed,
      bandGreen: bandGreen ?? this.bandGreen,
      bandNir: bandNir ?? this.bandNir,
      proyeksiProtasStep3:
      proyeksiProtasStep3 ?? this.proyeksiProtasStep3,
      ganodermaStep3: ganodermaStep3 ?? this.ganodermaStep3,
      statusHaraTanahStep3:
      statusHaraTanahStep3 ?? this.statusHaraTanahStep3,
      nilaiNStep3: nilaiNStep3 ?? this.nilaiNStep3,
      nilaiPStep3: nilaiPStep3 ?? this.nilaiPStep3,
      nilaiKStep3: nilaiKStep3 ?? this.nilaiKStep3,
      nilaiCaStep3: nilaiCaStep3 ?? this.nilaiCaStep3,
      nilaiMgStep3: nilaiMgStep3 ?? this.nilaiMgStep3,
    );
  }
}