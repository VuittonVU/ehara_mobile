import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/wilayah_item.dart';
import '../services/form_api_service.dart';
import '../services/form_draft_service.dart';
import '../services/wilayah_service.dart';
import 'form_state.dart';

final wilayahServiceProvider = Provider<WilayahService>((ref) {
  return WilayahService();
});

final formDraftServiceProvider = Provider<FormDraftService>((ref) {
  return FormDraftService();
});

final formApiServiceProvider = Provider<FormApiService>((ref) {
  return FormApiService();
});

final formNotifierProvider =
NotifierProvider<FormNotifier, TambahFormState>(FormNotifier.new);

class FormNotifier extends Notifier<TambahFormState> {
  Timer? _autoSaveDebounce;

  WilayahService get _wilayahService => ref.read(wilayahServiceProvider);
  FormDraftService get _draftService => ref.read(formDraftServiceProvider);
  FormApiService get _apiService => ref.read(formApiServiceProvider);

  @override
  TambahFormState build() {
    ref.onDispose(() {
      _autoSaveDebounce?.cancel();
    });
    return TambahFormState.initial();
  }

  Future<void> initialize() async {
    if (state.initialized) return;

    state = state.copyWith(initialized: true);
    await checkDraft();
    await loadProvinsi();
  }

  Future<void> checkDraft() async {
    final hasDraft = await _draftService.hasDraft();
    state = state.copyWith(hasDraft: hasDraft);
  }

  Future<void> loadDraft() async {
    final draft = await _draftService.loadDraft();
    if (draft == null) return;

    state = _stateFromDraft(draft).copyWith(
      hasDraft: true,
      clearTemporaryImage: true,
    );

    if (state.selectedProvinsi != null) {
      await loadKabupaten(state.selectedProvinsi!.code, notifyLoading: false);
    }

    if (state.selectedKabupaten != null && state.selectedProvinsi != null) {
      await loadKecamatan(
        provinceCode: state.selectedProvinsi!.code,
        kabupatenCode: state.selectedKabupaten!.code,
        notifyLoading: false,
      );
    }

    state = state.copyWith(hasDraft: true);
  }

  Future<void> saveDraft({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isSavingDraft: true);
    }

    try {
      await _draftService.saveDraft(_toDraftMap());
      state = state.copyWith(hasDraft: true);
    } finally {
      if (!silent) {
        state = state.copyWith(isSavingDraft: false);
      }
    }
  }

  void _scheduleAutoSave() {
    _autoSaveDebounce?.cancel();
    _autoSaveDebounce = Timer(const Duration(milliseconds: 500), () async {
      await saveDraft(silent: true);
    });
  }

  void _triggerFieldUpdate(TambahFormState nextState) {
    state = nextState;
    _scheduleAutoSave();
  }

  Future<void> clearDraft() async {
    _autoSaveDebounce?.cancel();
    await _draftService.clearDraft();
    state = state.copyWith(hasDraft: false);
  }

  void resetForm() {
    final keepProvinsiList = state.provinsiList;

    _autoSaveDebounce?.cancel();
    state = TambahFormState.initial().copyWith(
      initialized: state.initialized,
      provinsiList: keepProvinsiList,
      hasDraft: false,
    );
  }

  Future<void> resetAndClearDraft() async {
    resetForm();
    await clearDraft();
  }

  Future<void> loadProvinsi() async {
    state = state.copyWith(
      isLoadingProvinsi: true,
      clearErrorMessage: true,
    );

    try {
      final result = await _wilayahService.fetchProvinsi();
      state = state.copyWith(provinsiList: result);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoadingProvinsi: false);
    }
  }

  Future<void> loadKabupaten(
      String provinceCode, {
        bool notifyLoading = true,
      }) async {
    if (notifyLoading) {
      state = state.copyWith(
        isLoadingKabupaten: true,
        clearErrorMessage: true,
      );
    }

    try {
      final result =
      await _wilayahService.fetchKabupaten(provinceCode: provinceCode);
      state = state.copyWith(kabupatenList: result);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        kabupatenList: const [],
      );
    } finally {
      if (notifyLoading) {
        state = state.copyWith(isLoadingKabupaten: false);
      }
    }
  }

  Future<void> loadKecamatan({
    required String provinceCode,
    required String kabupatenCode,
    bool notifyLoading = true,
  }) async {
    if (notifyLoading) {
      state = state.copyWith(
        isLoadingKecamatan: true,
        clearErrorMessage: true,
      );
    }

    try {
      final result = await _wilayahService.fetchKecamatan(
        provinceCode: provinceCode,
        kabupatenCode: kabupatenCode,
      );
      state = state.copyWith(kecamatanList: result);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        kecamatanList: const [],
      );
    } finally {
      if (notifyLoading) {
        state = state.copyWith(isLoadingKecamatan: false);
      }
    }
  }

  Future<void> selectProvinsi(WilayahItem? value) async {
    state = state.copyWith(
      selectedProvinsi: value,
      clearSelectedKabupaten: true,
      clearSelectedKecamatan: true,
      kabupatenList: const [],
      kecamatanList: const [],
    );

    if (value != null) {
      state = state.copyWith(
        isLoadingKabupaten: true,
        clearErrorMessage: true,
      );

      try {
        final result =
        await _wilayahService.fetchKabupaten(provinceCode: value.code);
        state = state.copyWith(kabupatenList: result);
      } catch (e) {
        state = state.copyWith(
          errorMessage: e.toString(),
          kabupatenList: const [],
        );
      } finally {
        state = state.copyWith(isLoadingKabupaten: false);
      }
    }

    _scheduleAutoSave();
  }

  Future<void> selectKabupaten(WilayahItem? value) async {
    state = state.copyWith(
      selectedKabupaten: value,
      clearSelectedKecamatan: true,
      kecamatanList: const [],
    );

    if (value != null && state.selectedProvinsi != null) {
      state = state.copyWith(
        isLoadingKecamatan: true,
        clearErrorMessage: true,
      );

      try {
        final result = await _wilayahService.fetchKecamatan(
          provinceCode: state.selectedProvinsi!.code,
          kabupatenCode: value.code,
        );
        state = state.copyWith(kecamatanList: result);
      } catch (e) {
        state = state.copyWith(
          errorMessage: e.toString(),
          kecamatanList: const [],
        );
      } finally {
        state = state.copyWith(isLoadingKecamatan: false);
      }
    }

    _scheduleAutoSave();
  }

  void selectKecamatan(WilayahItem? value) {
    _triggerFieldUpdate(state.copyWith(selectedKecamatan: value));
  }

  void setFileName(String value, {String filePath = ''}) {
    _triggerFieldUpdate(
      state.copyWith(
        fileName: value,
        filePath: filePath,
      ),
    );
  }

  void setTemporaryImage({
    required Uint8List bytes,
    required String imageName,
  }) {
    state = state.copyWith(
      temporaryImageBytes: bytes,
      temporaryImageName: imageName,
    );
  }

  void clearTemporaryImage() {
    state = state.copyWith(clearTemporaryImage: true);
  }

  void setNamaProjek(String value) {
    _triggerFieldUpdate(state.copyWith(namaProjek: value));
  }

  void setNamaPerusahaan(String value) {
    _triggerFieldUpdate(state.copyWith(namaPerusahaan: value));
  }

  void setNamaKebun(String value) {
    _triggerFieldUpdate(state.copyWith(namaKebun: value));
  }

  void setDetailLokasi(String value) {
    _triggerFieldUpdate(state.copyWith(detailLokasi: value));
  }

  void setTanggalPengambilan(String value) {
    _triggerFieldUpdate(state.copyWith(tanggalPengambilan: value));
  }

  void setTanggalAnalisis(String value) {
    _triggerFieldUpdate(state.copyWith(tanggalAnalisis: value));
  }

  void setSensor(String value) {
    _triggerFieldUpdate(state.copyWith(sensor: value));
  }

  void setGanodermaStep1(String value) {
    _triggerFieldUpdate(state.copyWith(ganodermaStep1: value));
  }

  void setTahunTanam(String value) {
    _triggerFieldUpdate(state.copyWith(tahunTanam: value));
  }

  void setNomorKcd(String value) {
    _triggerFieldUpdate(state.copyWith(nomorKcd: value));
  }

  void setBlok(String value) {
    _triggerFieldUpdate(state.copyWith(blok: value));
  }

  void setLuasHa(String value) {
    _triggerFieldUpdate(state.copyWith(luasHa: value));
  }

  void setJumlahPohonHa(String value) {
    _triggerFieldUpdate(state.copyWith(jumlahPohonHa: value));
  }

  void setProtas(String value) {
    _triggerFieldUpdate(state.copyWith(protas: value));
  }

  void setProyeksiProtasStep2(String value) {
    _triggerFieldUpdate(state.copyWith(proyeksiProtasStep2: value));
  }

  void setGanodermaStep2(String value) {
    _triggerFieldUpdate(state.copyWith(ganodermaStep2: value));
  }

  void setStatusHaraTanahStep2(String value) {
    _triggerFieldUpdate(state.copyWith(statusHaraTanahStep2: value));
  }

  void setNilaiNStep2(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiNStep2: value));
  }

  void setNilaiPStep2(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiPStep2: value));
  }

  void setNilaiKStep2(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiKStep2: value));
  }

  void setNilaiCaStep2(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiCaStep2: value));
  }

  void setNilaiMgStep2(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiMgStep2: value));
  }

  void setLocation({
    required double lat,
    required double lng,
  }) {
    _triggerFieldUpdate(
      state.copyWith(
        latitude: lat,
        longitude: lng,
      ),
    );
  }

  void setIdTitik(String value) {
    _triggerFieldUpdate(state.copyWith(idTitik: value));
  }

  void setBandRed(String value) {
    _triggerFieldUpdate(state.copyWith(bandRed: value));
  }

  void setBandGreen(String value) {
    _triggerFieldUpdate(state.copyWith(bandGreen: value));
  }

  void setBandNir(String value) {
    _triggerFieldUpdate(state.copyWith(bandNir: value));
  }

  void setProyeksiProtasStep3(String value) {
    _triggerFieldUpdate(state.copyWith(proyeksiProtasStep3: value));
  }

  void setGanodermaStep3(String value) {
    _triggerFieldUpdate(state.copyWith(ganodermaStep3: value));
  }

  void setStatusHaraTanahStep3(String value) {
    _triggerFieldUpdate(state.copyWith(statusHaraTanahStep3: value));
  }

  void setNilaiNStep3(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiNStep3: value));
  }

  void setNilaiPStep3(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiPStep3: value));
  }

  void setNilaiKStep3(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiKStep3: value));
  }

  void setNilaiCaStep3(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiCaStep3: value));
  }

  void setNilaiMgStep3(String value) {
    _triggerFieldUpdate(state.copyWith(nilaiMgStep3: value));
  }

  String? validateStep1Message() {
    if (state.fileName.trim().isEmpty || state.filePath.trim().isEmpty) {
      return 'File analisis wajib dipilih dulu.';
    }
    if (state.namaProjek.trim().isEmpty) return 'Nama projek wajib diisi.';
    if (state.namaPerusahaan.trim().isEmpty) return 'Nama perusahaan wajib diisi.';
    if (state.namaKebun.trim().isEmpty) return 'Nama kebun wajib diisi.';
    if (state.selectedProvinsi == null) return 'Provinsi wajib dipilih.';
    if (state.selectedKabupaten == null) return 'Kota/Kabupaten wajib dipilih.';
    if (state.selectedKecamatan == null) return 'Kecamatan wajib dipilih.';
    if (state.detailLokasi.trim().isEmpty) return 'Detail lokasi wajib diisi.';
    if (state.tanggalPengambilan.trim().isEmpty) return 'Tanggal pengambilan wajib diisi.';
    if (state.tanggalAnalisis.trim().isEmpty) return 'Tanggal analisis wajib diisi.';
    if (state.sensor.trim().isEmpty) return 'Sensor wajib dipilih.';
    if (state.ganodermaStep1.trim().isEmpty) return 'Pilihan Ganoderma wajib dipilih.';
    return null;
  }

  String? validateStep2Message() {
    if (!_isInt(state.tahunTanam)) return 'Tahun tanam harus berupa angka bulat.';
    if (state.nomorKcd.trim().isEmpty) return 'Nomor KCD wajib diisi.';
    if (state.blok.trim().isEmpty) return 'Blok wajib diisi.';
    if (!_isDecimal(state.luasHa)) return 'Luas HA harus berupa angka.';
    if (!_isInt(state.jumlahPohonHa)) return 'Jumlah pohon/HA harus berupa angka bulat.';
    if (!_isDecimal(state.protas)) return 'Protas harus berupa angka.';
    if (!_isDecimal(state.proyeksiProtasStep2)) return 'Proyeksi protas harus berupa angka.';
    if (state.statusHaraTanahStep2.trim().isEmpty) return 'Status hara tanah wajib dipilih.';

    if (state.showSoilFieldsStep2) {
      if (!_isDecimal(state.nilaiNStep2)) return 'Nilai N harus berupa angka.';
      if (!_isDecimal(state.nilaiPStep2)) return 'Nilai P harus berupa angka.';
      if (!_isDecimal(state.nilaiKStep2)) return 'Nilai K harus berupa angka.';
      if (!_isDecimal(state.nilaiCaStep2)) return 'Nilai Ca harus berupa angka.';
      if (!_isDecimal(state.nilaiMgStep2)) return 'Nilai Mg harus berupa angka.';
    }

    return null;
  }

  String? validateStep3Message() {
    return _apiService.validateSubmission(state);
  }

  bool _isInt(String value) => int.tryParse(value.trim()) != null;

  bool _isDecimal(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.')) != null;

  bool validateStep1() {
    return validateStep1Message() == null;
  }

  bool validateStep2() {
    return validateStep2Message() == null;
  }

  bool validateStep3() {
    return validateStep3Message() == null;
  }

  Future<void> submitTambahAnalisis() async {
    state = state.copyWith(isSavingDraft: true, clearErrorMessage: true);

    try {
      await _apiService.submitTambahAnalisis(state);
      await clearDraft();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isSavingDraft: false);
    }
  }

  Map<String, dynamic> buildSubmissionPayload() {
    return {
      'step1': {
        'fileName': state.fileName,
        'temporaryImageName': state.temporaryImageName,
        'namaProjek': state.namaProjek,
        'namaPerusahaan': state.namaPerusahaan,
        'namaKebun': state.namaKebun,
        'provinsi': state.selectedProvinsi?.name,
        'kodeProvinsi': state.selectedProvinsi?.code,
        'kabupaten': state.selectedKabupaten?.name,
        'kodeKabupaten': state.selectedKabupaten?.code,
        'kecamatan': state.selectedKecamatan?.name,
        'kodeKecamatan': state.selectedKecamatan?.code,
        'detailLokasi': state.detailLokasi,
        'tanggalPengambilan': state.tanggalPengambilan,
        'tanggalAnalisis': state.tanggalAnalisis,
        'sensor': state.sensor,
        'ganoderma': state.ganodermaStep1,
      },
      'step2': {
        'tahunTanam': state.tahunTanam,
        'nomorKcd': state.nomorKcd,
        'blok': state.blok,
        'luasHa': state.luasHa,
        'jumlahPohonHa': state.jumlahPohonHa,
        'protas': state.protas,
        'proyeksiProtas': state.proyeksiProtasStep2,
        'ganoderma': state.ganodermaStep2,
        'statusHaraTanah': state.statusHaraTanahStep2,
        'nilaiN': state.nilaiNStep2,
        'nilaiP': state.nilaiPStep2,
        'nilaiK': state.nilaiKStep2,
        'nilaiCa': state.nilaiCaStep2,
        'nilaiMg': state.nilaiMgStep2,
      },
      'step3': {
        'latitude': state.latitude,
        'longitude': state.longitude,
        'idTitik': state.idTitik,
        'bandRed': state.bandRed,
        'bandGreen': state.bandGreen,
        'bandNir': state.bandNir,
        'proyeksiProtas': state.proyeksiProtasStep3,
        'ganoderma': state.ganodermaStep3,
        'statusHaraTanah': state.statusHaraTanahStep3,
        'nilaiN': state.nilaiNStep3,
        'nilaiP': state.nilaiPStep3,
        'nilaiK': state.nilaiKStep3,
        'nilaiCa': state.nilaiCaStep3,
        'nilaiMg': state.nilaiMgStep3,
      },
    };
  }

  Map<String, dynamic> _toDraftMap() {
    return {
      'fileName': state.fileName,
      'filePath': state.filePath,
      'namaProjek': state.namaProjek,
      'namaPerusahaan': state.namaPerusahaan,
      'namaKebun': state.namaKebun,
      'detailLokasi': state.detailLokasi,
      'tanggalPengambilan': state.tanggalPengambilan,
      'tanggalAnalisis': state.tanggalAnalisis,
      'sensor': state.sensor,
      'ganodermaStep1': state.ganodermaStep1,
      'selectedProvinsiCode': state.selectedProvinsi?.code,
      'selectedProvinsiName': state.selectedProvinsi?.name,
      'selectedKabupatenCode': state.selectedKabupaten?.code,
      'selectedKabupatenName': state.selectedKabupaten?.name,
      'selectedKecamatanCode': state.selectedKecamatan?.code,
      'selectedKecamatanName': state.selectedKecamatan?.name,
      'tahunTanam': state.tahunTanam,
      'nomorKcd': state.nomorKcd,
      'blok': state.blok,
      'luasHa': state.luasHa,
      'jumlahPohonHa': state.jumlahPohonHa,
      'protas': state.protas,
      'proyeksiProtasStep2': state.proyeksiProtasStep2,
      'ganodermaStep2': state.ganodermaStep2,
      'statusHaraTanahStep2': state.statusHaraTanahStep2,
      'nilaiNStep2': state.nilaiNStep2,
      'nilaiPStep2': state.nilaiPStep2,
      'nilaiKStep2': state.nilaiKStep2,
      'nilaiCaStep2': state.nilaiCaStep2,
      'nilaiMgStep2': state.nilaiMgStep2,
      'latitude': state.latitude,
      'longitude': state.longitude,
      'idTitik': state.idTitik,
      'bandRed': state.bandRed,
      'bandGreen': state.bandGreen,
      'bandNir': state.bandNir,
      'proyeksiProtasStep3': state.proyeksiProtasStep3,
      'ganodermaStep3': state.ganodermaStep3,
      'statusHaraTanahStep3': state.statusHaraTanahStep3,
      'nilaiNStep3': state.nilaiNStep3,
      'nilaiPStep3': state.nilaiPStep3,
      'nilaiKStep3': state.nilaiKStep3,
      'nilaiCaStep3': state.nilaiCaStep3,
      'nilaiMgStep3': state.nilaiMgStep3,
    };
  }

  TambahFormState _stateFromDraft(Map<String, dynamic> draft) {
    final provCode = (draft['selectedProvinsiCode'] ?? '').toString();
    final provName = (draft['selectedProvinsiName'] ?? '').toString();

    final kabCode = (draft['selectedKabupatenCode'] ?? '').toString();
    final kabName = (draft['selectedKabupatenName'] ?? '').toString();

    final kecCode = (draft['selectedKecamatanCode'] ?? '').toString();
    final kecName = (draft['selectedKecamatanName'] ?? '').toString();

    return state.copyWith(
      fileName: (draft['fileName'] ?? '').toString(),
      filePath: (draft['filePath'] ?? '').toString(),
      clearTemporaryImage: true,
      namaProjek: (draft['namaProjek'] ?? '').toString(),
      namaPerusahaan: (draft['namaPerusahaan'] ?? '').toString(),
      namaKebun: (draft['namaKebun'] ?? '').toString(),
      detailLokasi: (draft['detailLokasi'] ?? '').toString(),
      tanggalPengambilan: (draft['tanggalPengambilan'] ?? '').toString(),
      tanggalAnalisis: (draft['tanggalAnalisis'] ?? '').toString(),
      sensor: (draft['sensor'] ?? 'Micasense').toString(),
      ganodermaStep1: (draft['ganodermaStep1'] ?? 'Ya').toString(),
      selectedProvinsi: (provCode.isNotEmpty || provName.isNotEmpty)
          ? WilayahItem(code: provCode, name: provName)
          : null,
      selectedKabupaten: (kabCode.isNotEmpty || kabName.isNotEmpty)
          ? WilayahItem(code: kabCode, name: kabName)
          : null,
      selectedKecamatan: (kecCode.isNotEmpty || kecName.isNotEmpty)
          ? WilayahItem(code: kecCode, name: kecName)
          : null,
      tahunTanam: (draft['tahunTanam'] ?? '').toString(),
      nomorKcd: (draft['nomorKcd'] ?? '').toString(),
      blok: (draft['blok'] ?? '').toString(),
      luasHa: (draft['luasHa'] ?? '').toString(),
      jumlahPohonHa: (draft['jumlahPohonHa'] ?? '').toString(),
      protas: (draft['protas'] ?? '').toString(),
      proyeksiProtasStep2: (draft['proyeksiProtasStep2'] ?? '').toString(),
      ganodermaStep2: (draft['ganodermaStep2'] ?? 'Ya').toString(),
      statusHaraTanahStep2:
      (draft['statusHaraTanahStep2'] ?? 'Ada Nilai Hara Tanah').toString(),
      nilaiNStep2: (draft['nilaiNStep2'] ?? '').toString(),
      nilaiPStep2: (draft['nilaiPStep2'] ?? '').toString(),
      nilaiKStep2: (draft['nilaiKStep2'] ?? '').toString(),
      nilaiCaStep2: (draft['nilaiCaStep2'] ?? '').toString(),
      nilaiMgStep2: (draft['nilaiMgStep2'] ?? '').toString(),
      latitude: draft['latitude'] is num
          ? (draft['latitude'] as num).toDouble()
          : double.tryParse((draft['latitude'] ?? '').toString()),
      longitude: draft['longitude'] is num
          ? (draft['longitude'] as num).toDouble()
          : double.tryParse((draft['longitude'] ?? '').toString()),
      idTitik: (draft['idTitik'] ?? '').toString(),
      bandRed: (draft['bandRed'] ?? 'Red').toString(),
      bandGreen: (draft['bandGreen'] ?? 'Green').toString(),
      bandNir: (draft['bandNir'] ?? 'NIR').toString(),
      proyeksiProtasStep3:
      (draft['proyeksiProtasStep3'] ?? '').toString(),
      ganodermaStep3: (draft['ganodermaStep3'] ?? 'Ya').toString(),
      statusHaraTanahStep3:
      (draft['statusHaraTanahStep3'] ?? 'Ada Nilai Hara Tanah').toString(),
      nilaiNStep3: (draft['nilaiNStep3'] ?? '').toString(),
      nilaiPStep3: (draft['nilaiPStep3'] ?? '').toString(),
      nilaiKStep3: (draft['nilaiKStep3'] ?? '').toString(),
      nilaiCaStep3: (draft['nilaiCaStep3'] ?? '').toString(),
      nilaiMgStep3: (draft['nilaiMgStep3'] ?? '').toString(),
    );
  }
}