import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/wilayah_item.dart';
import '../services/form_draft_service.dart';
import '../services/wilayah_service.dart';

class FormProvider extends ChangeNotifier {
  final WilayahService _wilayahService;
  final FormDraftService _draftService;

  Timer? _autoSaveDebounce;

  FormProvider({
    WilayahService? wilayahService,
    FormDraftService? draftService,
  })  : _wilayahService = wilayahService ?? WilayahService(),
        _draftService = draftService ?? FormDraftService();

  bool _initialized = false;
  bool get initialized => _initialized;

  bool _isLoadingProvinsi = false;
  bool get isLoadingProvinsi => _isLoadingProvinsi;

  bool _isLoadingKabupaten = false;
  bool get isLoadingKabupaten => _isLoadingKabupaten;

  bool _isLoadingKecamatan = false;
  bool get isLoadingKecamatan => _isLoadingKecamatan;

  bool _isSavingDraft = false;
  bool get isSavingDraft => _isSavingDraft;

  bool _hasDraft = false;
  bool get hasDraft => _hasDraft;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // STEP 1
  String fileName = '';
  String namaProjek = '';
  String namaPerusahaan = '';
  String namaKebun = '';
  String detailLokasi = '';
  String tanggalPengambilan = '';
  String tanggalAnalisis = '';
  String sensor = '';
  String ganodermaStep1 = '';

  List<WilayahItem> provinsiList = [];
  List<WilayahItem> kabupatenList = [];
  List<WilayahItem> kecamatanList = [];

  WilayahItem? selectedProvinsi;
  WilayahItem? selectedKabupaten;
  WilayahItem? selectedKecamatan;

  // STEP 2
  String tahunTanam = '';
  String nomorKcd = '';
  String blok = '';
  String luasHa = '';
  String jumlahPohonHa = '';
  String protas = '';
  String proyeksiProtasStep2 = '';
  String ganodermaStep2 = 'Ya';
  String statusHaraTanahStep2 = 'Ada Nilai Hara Tanah';

  String nilaiNStep2 = '';
  String nilaiPStep2 = '';
  String nilaiKStep2 = '';
  String nilaiCaStep2 = '';
  String nilaiMgStep2 = '';

  // STEP 3
  double? latitude;
  double? longitude;

  String idTitik = '';
  String bandRed = '';
  String bandGreen = '';
  String bandNir = '';
  String proyeksiProtasStep3 = '';
  String ganodermaStep3 = '';
  String statusHaraTanahStep3 = '';

  String nilaiNStep3 = '';
  String nilaiPStep3 = '';
  String nilaiKStep3 = '';
  String nilaiCaStep3 = '';
  String nilaiMgStep3 = '';

  bool get showSoilFieldsStep2 =>
      statusHaraTanahStep2 == 'Ada Nilai Hara Tanah';

  bool get showSoilFieldsStep3 =>
      statusHaraTanahStep3 == 'Ada Nilai Hara Tanah';

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;
    await checkDraft();
    await loadProvinsi();
    notifyListeners();
  }

  Future<void> checkDraft() async {
    _hasDraft = await _draftService.hasDraft();
    notifyListeners();
  }

  Future<void> loadDraft() async {
    final draft = await _draftService.loadDraft();
    if (draft == null) return;

    _applyDraft(draft);

    if (selectedProvinsi != null) {
      await loadKabupaten(selectedProvinsi!.code, notify: false);
    }

    if (selectedKabupaten != null && selectedProvinsi != null) {
      await loadKecamatan(
        provinceCode: selectedProvinsi!.code,
        kabupatenCode: selectedKabupaten!.code,
        notify: false,
      );
    }

    _hasDraft = true;
    notifyListeners();
  }

  Future<void> saveDraft({bool silent = false}) async {
    if (!silent) {
      _isSavingDraft = true;
      notifyListeners();
    }

    try {
      await _draftService.saveDraft(_toDraftMap());
      _hasDraft = true;
    } finally {
      if (!silent) {
        _isSavingDraft = false;
        notifyListeners();
      }
    }
  }

  void _scheduleAutoSave() {
    _autoSaveDebounce?.cancel();
    _autoSaveDebounce = Timer(const Duration(milliseconds: 500), () async {
      await saveDraft(silent: true);
      notifyListeners();
    });
  }

  void _triggerFieldUpdate() {
    notifyListeners();
    _scheduleAutoSave();
  }

  Future<void> clearDraft() async {
    _autoSaveDebounce?.cancel();
    await _draftService.clearDraft();
    _hasDraft = false;
    notifyListeners();
  }

  void resetForm() {
    _autoSaveDebounce?.cancel();

    fileName = '';
    namaProjek = '';
    namaPerusahaan = '';
    namaKebun = '';
    detailLokasi = '';
    tanggalPengambilan = '';
    tanggalAnalisis = '';
    sensor = '';
    ganodermaStep1 = '';

    selectedProvinsi = null;
    selectedKabupaten = null;
    selectedKecamatan = null;
    kabupatenList = [];
    kecamatanList = [];

    tahunTanam = '';
    nomorKcd = '';
    blok = '';
    luasHa = '';
    jumlahPohonHa = '';
    protas = '';
    proyeksiProtasStep2 = '';
    ganodermaStep2 = 'Ya';
    statusHaraTanahStep2 = 'Ada Nilai Hara Tanah';

    nilaiNStep2 = '';
    nilaiPStep2 = '';
    nilaiKStep2 = '';
    nilaiCaStep2 = '';
    nilaiMgStep2 = '';

    latitude = null;
    longitude = null;

    idTitik = '';
    bandRed = '';
    bandGreen = '';
    bandNir = '';
    proyeksiProtasStep3 = '';
    ganodermaStep3 = '';
    statusHaraTanahStep3 = '';

    nilaiNStep3 = '';
    nilaiPStep3 = '';
    nilaiKStep3 = '';
    nilaiCaStep3 = '';
    nilaiMgStep3 = '';

    _errorMessage = null;
    notifyListeners();
  }

  Future<void> resetAndClearDraft() async {
    resetForm();
    await clearDraft();
  }

  Future<void> loadProvinsi() async {
    _isLoadingProvinsi = true;
    _errorMessage = null;
    notifyListeners();

    try {
      provinsiList = await _wilayahService.fetchProvinsi();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingProvinsi = false;
      notifyListeners();
    }
  }

  Future<void> loadKabupaten(
      String provinceCode, {
        bool notify = true,
      }) async {
    _isLoadingKabupaten = true;
    _errorMessage = null;
    if (notify) notifyListeners();

    try {
      kabupatenList = await _wilayahService.fetchKabupaten(
        provinceCode: provinceCode,
      );
    } catch (e) {
      _errorMessage = e.toString();
      kabupatenList = [];
    } finally {
      _isLoadingKabupaten = false;
      if (notify) notifyListeners();
    }
  }

  Future<void> loadKecamatan({
    required String provinceCode,
    required String kabupatenCode,
    bool notify = true,
  }) async {
    _isLoadingKecamatan = true;
    _errorMessage = null;
    if (notify) notifyListeners();

    try {
      kecamatanList = await _wilayahService.fetchKecamatan(
        provinceCode: provinceCode,
        kabupatenCode: kabupatenCode,
      );
    } catch (e) {
      _errorMessage = e.toString();
      kecamatanList = [];
    } finally {
      _isLoadingKecamatan = false;
      if (notify) notifyListeners();
    }
  }

  Future<void> selectProvinsi(WilayahItem? value) async {
    selectedProvinsi = value;
    selectedKabupaten = null;
    selectedKecamatan = null;
    kabupatenList = [];
    kecamatanList = [];
    notifyListeners();

    if (value != null) {
      await loadKabupaten(value.code);
    }

    _scheduleAutoSave();
  }

  Future<void> selectKabupaten(WilayahItem? value) async {
    selectedKabupaten = value;
    selectedKecamatan = null;
    kecamatanList = [];
    notifyListeners();

    if (value != null && selectedProvinsi != null) {
      await loadKecamatan(
        provinceCode: selectedProvinsi!.code,
        kabupatenCode: value.code,
      );
    }

    _scheduleAutoSave();
  }

  void selectKecamatan(WilayahItem? value) {
    selectedKecamatan = value;
    _triggerFieldUpdate();
  }

  void setFileName(String value) {
    fileName = value;
    _triggerFieldUpdate();
  }

  void setNamaProjek(String value) {
    namaProjek = value;
    _triggerFieldUpdate();
  }

  void setNamaPerusahaan(String value) {
    namaPerusahaan = value;
    _triggerFieldUpdate();
  }

  void setNamaKebun(String value) {
    namaKebun = value;
    _triggerFieldUpdate();
  }

  void setDetailLokasi(String value) {
    detailLokasi = value;
    _triggerFieldUpdate();
  }

  void setTanggalPengambilan(String value) {
    tanggalPengambilan = value;
    _triggerFieldUpdate();
  }

  void setTanggalAnalisis(String value) {
    tanggalAnalisis = value;
    _triggerFieldUpdate();
  }

  void setSensor(String value) {
    sensor = value;
    _triggerFieldUpdate();
  }

  void setGanodermaStep1(String value) {
    ganodermaStep1 = value;
    _triggerFieldUpdate();
  }

  void setTahunTanam(String value) {
    tahunTanam = value;
    _triggerFieldUpdate();
  }

  void setNomorKcd(String value) {
    nomorKcd = value;
    _triggerFieldUpdate();
  }

  void setBlok(String value) {
    blok = value;
    _triggerFieldUpdate();
  }

  void setLuasHa(String value) {
    luasHa = value;
    _triggerFieldUpdate();
  }

  void setJumlahPohonHa(String value) {
    jumlahPohonHa = value;
    _triggerFieldUpdate();
  }

  void setProtas(String value) {
    protas = value;
    _triggerFieldUpdate();
  }

  void setProyeksiProtasStep2(String value) {
    proyeksiProtasStep2 = value;
    _triggerFieldUpdate();
  }

  void setGanodermaStep2(String value) {
    ganodermaStep2 = value;
    _triggerFieldUpdate();
  }

  void setStatusHaraTanahStep2(String value) {
    statusHaraTanahStep2 = value;
    _triggerFieldUpdate();
  }

  void setNilaiNStep2(String value) {
    nilaiNStep2 = value;
    _triggerFieldUpdate();
  }

  void setNilaiPStep2(String value) {
    nilaiPStep2 = value;
    _triggerFieldUpdate();
  }

  void setNilaiKStep2(String value) {
    nilaiKStep2 = value;
    _triggerFieldUpdate();
  }

  void setNilaiCaStep2(String value) {
    nilaiCaStep2 = value;
    _triggerFieldUpdate();
  }

  void setNilaiMgStep2(String value) {
    nilaiMgStep2 = value;
    _triggerFieldUpdate();
  }

  void setLocation({
    required double lat,
    required double lng,
  }) {
    latitude = lat;
    longitude = lng;
    _triggerFieldUpdate();
  }

  void setIdTitik(String value) {
    idTitik = value;
    _triggerFieldUpdate();
  }

  void setBandRed(String value) {
    bandRed = value;
    _triggerFieldUpdate();
  }

  void setBandGreen(String value) {
    bandGreen = value;
    _triggerFieldUpdate();
  }

  void setBandNir(String value) {
    bandNir = value;
    _triggerFieldUpdate();
  }

  void setProyeksiProtasStep3(String value) {
    proyeksiProtasStep3 = value;
    _triggerFieldUpdate();
  }

  void setGanodermaStep3(String value) {
    ganodermaStep3 = value;
    _triggerFieldUpdate();
  }

  void setStatusHaraTanahStep3(String value) {
    statusHaraTanahStep3 = value;
    _triggerFieldUpdate();
  }

  void setNilaiNStep3(String value) {
    nilaiNStep3 = value;
    _triggerFieldUpdate();
  }

  void setNilaiPStep3(String value) {
    nilaiPStep3 = value;
    _triggerFieldUpdate();
  }

  void setNilaiKStep3(String value) {
    nilaiKStep3 = value;
    _triggerFieldUpdate();
  }

  void setNilaiCaStep3(String value) {
    nilaiCaStep3 = value;
    _triggerFieldUpdate();
  }

  void setNilaiMgStep3(String value) {
    nilaiMgStep3 = value;
    _triggerFieldUpdate();
  }

  bool validateStep1() {
    return namaProjek.trim().isNotEmpty &&
        namaPerusahaan.trim().isNotEmpty &&
        namaKebun.trim().isNotEmpty &&
        selectedProvinsi != null &&
        selectedKabupaten != null &&
        selectedKecamatan != null &&
        detailLokasi.trim().isNotEmpty &&
        tanggalPengambilan.trim().isNotEmpty &&
        tanggalAnalisis.trim().isNotEmpty &&
        sensor.trim().isNotEmpty &&
        ganodermaStep1.trim().isNotEmpty;
  }

  bool validateStep2() {
    final basicValid = tahunTanam.trim().isNotEmpty &&
        nomorKcd.trim().isNotEmpty &&
        blok.trim().isNotEmpty &&
        luasHa.trim().isNotEmpty &&
        jumlahPohonHa.trim().isNotEmpty &&
        protas.trim().isNotEmpty &&
        proyeksiProtasStep2.trim().isNotEmpty &&
        ganodermaStep2.trim().isNotEmpty &&
        statusHaraTanahStep2.trim().isNotEmpty;

    if (!basicValid) return false;

    if (!showSoilFieldsStep2) return true;

    return nilaiNStep2.trim().isNotEmpty &&
        nilaiPStep2.trim().isNotEmpty &&
        nilaiKStep2.trim().isNotEmpty &&
        nilaiCaStep2.trim().isNotEmpty &&
        nilaiMgStep2.trim().isNotEmpty;
  }

  bool validateStep3() {
    final basicValid = latitude != null &&
        longitude != null &&
        idTitik.trim().isNotEmpty &&
        bandRed.trim().isNotEmpty &&
        bandGreen.trim().isNotEmpty &&
        bandNir.trim().isNotEmpty &&
        proyeksiProtasStep3.trim().isNotEmpty &&
        ganodermaStep3.trim().isNotEmpty &&
        statusHaraTanahStep3.trim().isNotEmpty;

    if (!basicValid) return false;

    if (!showSoilFieldsStep3) return true;

    return nilaiNStep3.trim().isNotEmpty &&
        nilaiPStep3.trim().isNotEmpty &&
        nilaiKStep3.trim().isNotEmpty &&
        nilaiCaStep3.trim().isNotEmpty &&
        nilaiMgStep3.trim().isNotEmpty;
  }

  LatLng? get selectedLatLng {
    if (latitude == null || longitude == null) return null;
    return LatLng(latitude!, longitude!);
  }

  Map<String, dynamic> buildSubmissionPayload() {
    return {
      'step1': {
        'fileName': fileName,
        'namaProjek': namaProjek,
        'namaPerusahaan': namaPerusahaan,
        'namaKebun': namaKebun,
        'provinsi': selectedProvinsi?.name,
        'kodeProvinsi': selectedProvinsi?.code,
        'kabupaten': selectedKabupaten?.name,
        'kodeKabupaten': selectedKabupaten?.code,
        'kecamatan': selectedKecamatan?.name,
        'kodeKecamatan': selectedKecamatan?.code,
        'detailLokasi': detailLokasi,
        'tanggalPengambilan': tanggalPengambilan,
        'tanggalAnalisis': tanggalAnalisis,
        'sensor': sensor,
        'ganoderma': ganodermaStep1,
      },
      'step2': {
        'tahunTanam': tahunTanam,
        'nomorKcd': nomorKcd,
        'blok': blok,
        'luasHa': luasHa,
        'jumlahPohonHa': jumlahPohonHa,
        'protas': protas,
        'proyeksiProtas': proyeksiProtasStep2,
        'ganoderma': ganodermaStep2,
        'statusHaraTanah': statusHaraTanahStep2,
        'nilaiN': nilaiNStep2,
        'nilaiP': nilaiPStep2,
        'nilaiK': nilaiKStep2,
        'nilaiCa': nilaiCaStep2,
        'nilaiMg': nilaiMgStep2,
      },
      'step3': {
        'latitude': latitude,
        'longitude': longitude,
        'idTitik': idTitik,
        'bandRed': bandRed,
        'bandGreen': bandGreen,
        'bandNir': bandNir,
        'proyeksiProtas': proyeksiProtasStep3,
        'ganoderma': ganodermaStep3,
        'statusHaraTanah': statusHaraTanahStep3,
        'nilaiN': nilaiNStep3,
        'nilaiP': nilaiPStep3,
        'nilaiK': nilaiKStep3,
        'nilaiCa': nilaiCaStep3,
        'nilaiMg': nilaiMgStep3,
      },
    };
  }

  Map<String, dynamic> _toDraftMap() {
    return {
      'fileName': fileName,
      'namaProjek': namaProjek,
      'namaPerusahaan': namaPerusahaan,
      'namaKebun': namaKebun,
      'detailLokasi': detailLokasi,
      'tanggalPengambilan': tanggalPengambilan,
      'tanggalAnalisis': tanggalAnalisis,
      'sensor': sensor,
      'ganodermaStep1': ganodermaStep1,
      'selectedProvinsiCode': selectedProvinsi?.code,
      'selectedProvinsiName': selectedProvinsi?.name,
      'selectedKabupatenCode': selectedKabupaten?.code,
      'selectedKabupatenName': selectedKabupaten?.name,
      'selectedKecamatanCode': selectedKecamatan?.code,
      'selectedKecamatanName': selectedKecamatan?.name,
      'tahunTanam': tahunTanam,
      'nomorKcd': nomorKcd,
      'blok': blok,
      'luasHa': luasHa,
      'jumlahPohonHa': jumlahPohonHa,
      'protas': protas,
      'proyeksiProtasStep2': proyeksiProtasStep2,
      'ganodermaStep2': ganodermaStep2,
      'statusHaraTanahStep2': statusHaraTanahStep2,
      'nilaiNStep2': nilaiNStep2,
      'nilaiPStep2': nilaiPStep2,
      'nilaiKStep2': nilaiKStep2,
      'nilaiCaStep2': nilaiCaStep2,
      'nilaiMgStep2': nilaiMgStep2,
      'latitude': latitude,
      'longitude': longitude,
      'idTitik': idTitik,
      'bandRed': bandRed,
      'bandGreen': bandGreen,
      'bandNir': bandNir,
      'proyeksiProtasStep3': proyeksiProtasStep3,
      'ganodermaStep3': ganodermaStep3,
      'statusHaraTanahStep3': statusHaraTanahStep3,
      'nilaiNStep3': nilaiNStep3,
      'nilaiPStep3': nilaiPStep3,
      'nilaiKStep3': nilaiKStep3,
      'nilaiCaStep3': nilaiCaStep3,
      'nilaiMgStep3': nilaiMgStep3,
    };
  }

  void _applyDraft(Map<String, dynamic> draft) {
    fileName = (draft['fileName'] ?? '').toString();
    namaProjek = (draft['namaProjek'] ?? '').toString();
    namaPerusahaan = (draft['namaPerusahaan'] ?? '').toString();
    namaKebun = (draft['namaKebun'] ?? '').toString();
    detailLokasi = (draft['detailLokasi'] ?? '').toString();
    tanggalPengambilan = (draft['tanggalPengambilan'] ?? '').toString();
    tanggalAnalisis = (draft['tanggalAnalisis'] ?? '').toString();
    sensor = (draft['sensor'] ?? '').toString();
    ganodermaStep1 = (draft['ganodermaStep1'] ?? '').toString();

    final provCode = (draft['selectedProvinsiCode'] ?? '').toString();
    final provName = (draft['selectedProvinsiName'] ?? '').toString();
    if (provCode.isNotEmpty || provName.isNotEmpty) {
      selectedProvinsi = WilayahItem(code: provCode, name: provName);
    }

    final kabCode = (draft['selectedKabupatenCode'] ?? '').toString();
    final kabName = (draft['selectedKabupatenName'] ?? '').toString();
    if (kabCode.isNotEmpty || kabName.isNotEmpty) {
      selectedKabupaten = WilayahItem(code: kabCode, name: kabName);
    }

    final kecCode = (draft['selectedKecamatanCode'] ?? '').toString();
    final kecName = (draft['selectedKecamatanName'] ?? '').toString();
    if (kecCode.isNotEmpty || kecName.isNotEmpty) {
      selectedKecamatan = WilayahItem(code: kecCode, name: kecName);
    }

    tahunTanam = (draft['tahunTanam'] ?? '').toString();
    nomorKcd = (draft['nomorKcd'] ?? '').toString();
    blok = (draft['blok'] ?? '').toString();
    luasHa = (draft['luasHa'] ?? '').toString();
    jumlahPohonHa = (draft['jumlahPohonHa'] ?? '').toString();
    protas = (draft['protas'] ?? '').toString();
    proyeksiProtasStep2 = (draft['proyeksiProtasStep2'] ?? '').toString();
    ganodermaStep2 = (draft['ganodermaStep2'] ?? 'Ya').toString();
    statusHaraTanahStep2 =
        (draft['statusHaraTanahStep2'] ?? 'Ada Nilai Hara Tanah').toString();

    nilaiNStep2 = (draft['nilaiNStep2'] ?? '').toString();
    nilaiPStep2 = (draft['nilaiPStep2'] ?? '').toString();
    nilaiKStep2 = (draft['nilaiKStep2'] ?? '').toString();
    nilaiCaStep2 = (draft['nilaiCaStep2'] ?? '').toString();
    nilaiMgStep2 = (draft['nilaiMgStep2'] ?? '').toString();

    latitude = draft['latitude'] is num
        ? (draft['latitude'] as num).toDouble()
        : double.tryParse((draft['latitude'] ?? '').toString());

    longitude = draft['longitude'] is num
        ? (draft['longitude'] as num).toDouble()
        : double.tryParse((draft['longitude'] ?? '').toString());

    idTitik = (draft['idTitik'] ?? '').toString();
    bandRed = (draft['bandRed'] ?? '').toString();
    bandGreen = (draft['bandGreen'] ?? '').toString();
    bandNir = (draft['bandNir'] ?? '').toString();
    proyeksiProtasStep3 = (draft['proyeksiProtasStep3'] ?? '').toString();
    ganodermaStep3 = (draft['ganodermaStep3'] ?? '').toString();
    statusHaraTanahStep3 = (draft['statusHaraTanahStep3'] ?? '').toString();

    nilaiNStep3 = (draft['nilaiNStep3'] ?? '').toString();
    nilaiPStep3 = (draft['nilaiPStep3'] ?? '').toString();
    nilaiKStep3 = (draft['nilaiKStep3'] ?? '').toString();
    nilaiCaStep3 = (draft['nilaiCaStep3'] ?? '').toString();
    nilaiMgStep3 = (draft['nilaiMgStep3'] ?? '').toString();
  }

  @override
  void dispose() {
    _autoSaveDebounce?.cancel();
    super.dispose();
  }
}