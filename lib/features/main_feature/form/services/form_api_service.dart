import 'package:flutter/foundation.dart';

import '../../../../core/network/ehara_api_service.dart';
import '../../../onboarding/auth/services/auth_service.dart';
import '../providers/form_state.dart';

class FormApiService {
  FormApiService({EharaApiService? api})
      : _api = api ?? EharaApiService(baseUrl: AuthService.baseUrl);

  final EharaApiService _api;

  Future<void> submitTambahAnalisis(TambahFormState state) async {
    final validationError = validateSubmission(state);
    if (validationError != null) throw Exception(validationError);

    final uploadResponse = await _api.postMultipart(
      path: '/api/e-hara/upload-get-columns',
      endpointName: 'form step 1 upload-get-columns',
      fields: _buildStep1Fields(state),
      filePaths: {'file': state.filePath},
    );

    final nameFile = _extractString(uploadResponse, const [
      'data.data.name_file',
      'data.name_file',
      'name_file',
      'filename',
      'file_name',
    ]);

    final isKcd = _extractBool(uploadResponse, const [
      'data.data.kcd',
      'data.kcd',
      'kcd',
    ]);

    debugPrint('STEP 1 PARSED name_file: $nameFile');
    debugPrint('STEP 1 PARSED is_kcd: $isKcd');

    if (nameFile == null || nameFile.isEmpty) {
      debugPrint('STEP 1 RAW RESPONSE: $uploadResponse');
      throw Exception('Response step 1 tidak memiliki name_file dari server.');
    }

    final generateResponse = await _api.postMultipart(
      path: '/api/e-hara/generate-data-from-ganomon',
      endpointName: 'form step 2 generate-data-from-ganomon',
      fields: _buildStep2Fields(state, nameFile),
    );

    final tupleMessage = _extractString(generateResponse, const [
      'data.data.message',
      'data.message',
      'message',
    ]);

    _Step2TupleResult? parsedTuple;
    if (tupleMessage != null && tupleMessage.trim().startsWith('(')) {
      parsedTuple = _parseStep2Tuple(tupleMessage);
    }

    String? filename = parsedTuple?.filename;
    String? locationFilename = parsedTuple?.locationFilename;
    String? mapFilename = parsedTuple?.mapFilename;

    filename ??= _extractString(generateResponse, const [
      'data.data.filename',
      'data.data.file_name',
      'data.data.result_file',
      'data.filename',
      'data.file_name',
      'filename',
      'file_name',
      'result_file',
    ]);

    locationFilename ??= _extractString(generateResponse, const [
      'data.data.location_filename',
      'data.data.location_file',
      'data.location_filename',
      'data.location_file',
      'location_filename',
      'location_file',
    ]);

    mapFilename ??= _extractString(generateResponse, const [
      'data.data.map_filename',
      'data.data.map_file',
      'data.data.map',
      'data.map_filename',
      'data.map_file',
      'map_filename',
      'map_file',
      'map',
    ]);

    debugPrint('STEP 2 PARSED filename: $filename');
    debugPrint('STEP 2 PARSED location_filename: $locationFilename');
    debugPrint('STEP 2 PARSED map_filename: $mapFilename');

    if (filename == null || filename.isEmpty) {
      debugPrint('STEP 2 RAW RESPONSE: $generateResponse');
      throw Exception('Response step 2 tidak memiliki filename dari server.');
    }
    if (locationFilename == null || locationFilename.isEmpty) {
      debugPrint('STEP 2 RAW RESPONSE: $generateResponse');
      throw Exception('Response step 2 tidak memiliki location_filename dari server.');
    }
    if (mapFilename == null || mapFilename.isEmpty) {
      debugPrint('STEP 2 RAW RESPONSE: $generateResponse');
      throw Exception('Response step 2 tidak memiliki map_filename dari server.');
    }

    await _api.postMultipart(
      path: '/api/e-hara',
      endpointName: 'form step 3 save e-hara',
      fields: _buildStep3Fields(
        state,
        filename: filename,
        locationFilename: locationFilename,
        mapFilename: mapFilename,
        isKcd: isKcd,
      ),
    );
  }

  String? validateSubmission(TambahFormState state) {
    if (state.filePath.trim().isEmpty) {
      return 'File analisis wajib dipilih dulu.';
    }
    if (!_isAllowedFile(state.fileName)) {
      return 'Format file harus .xlsx, .xls, atau .csv.';
    }
    if (state.namaProjek.trim().isEmpty) return 'Nama projek wajib diisi.';
    if (state.namaPerusahaan.trim().isEmpty) return 'Nama perusahaan wajib diisi.';
    if (state.namaKebun.trim().isEmpty) return 'Nama kebun wajib diisi.';
    if (state.selectedProvinsi == null) return 'Provinsi wajib dipilih.';
    if (state.selectedKabupaten == null) return 'Kota/Kabupaten wajib dipilih.';
    if (state.selectedKecamatan == null) return 'Kecamatan wajib dipilih.';
    if (state.detailLokasi.trim().isEmpty) return 'Detail lokasi wajib diisi.';
    if (!_isValidDate(state.tanggalPengambilan)) {
      return 'Tanggal pengambilan harus format dd/mm/yyyy.';
    }
    if (!_isValidDate(state.tanggalAnalisis)) {
      return 'Tanggal analisis harus format dd/mm/yyyy.';
    }
    if (state.sensor.trim().isEmpty) return 'Sensor wajib dipilih.';

    if (!_isInt(state.tahunTanam)) return 'Tahun tanam harus berupa angka bulat.';
    if (!_isText(state.nomorKcd)) return 'Nomor KCD wajib diisi.';
    if (!_isText(state.blok)) return 'Blok wajib diisi.';
    if (!_isDecimal(state.luasHa)) return 'Luas HA harus berupa angka.';
    if (!_isInt(state.jumlahPohonHa)) {
      return 'Jumlah pohon/HA harus berupa angka bulat.';
    }
    if (!_isDecimal(state.protas)) return 'Protas harus berupa angka.';
    if (!_isDecimal(state.proyeksiProtasStep2)) {
      return 'Proyeksi protas pada Form 2 harus berupa angka.';
    }

    if (state.latitude == null || state.longitude == null) {
      return 'Lokasi X/Y wajib dipilih dari map.';
    }
    if (!_isText(state.idTitik)) return 'ID titik wajib diisi.';
    if (state.bandRed.trim().isEmpty) return 'Band Red wajib dipilih.';
    if (state.bandGreen.trim().isEmpty) return 'Band Green wajib dipilih.';
    if (state.bandNir.trim().isEmpty) return 'Band NIR wajib dipilih.';
    if (!_isDecimal(state.proyeksiProtasStep3)) {
      return 'Proyeksi protas pada Form 3 harus berupa angka.';
    }

    return null;
  }

  Map<String, String> _buildStep1Fields(TambahFormState state) {
    return {
      'project_name': state.namaProjek.trim(),
      'customer_name': state.namaPerusahaan.trim(),
      'customer_address': state.detailLokasi.trim(),
      'date': _toApiDate(state.tanggalAnalisis),
      'plantation_name': state.namaKebun.trim(),
      'company_name': state.namaPerusahaan.trim(),
      'location': state.detailLokasi.trim(),
      'location_province': state.selectedProvinsi?.name.toUpperCase() ?? '',
      'location_city': state.selectedKabupaten?.name.toUpperCase() ?? '',
      'location_subdistrict': state.selectedKecamatan?.name.toUpperCase() ?? '',
      'sensor_type': _normalizeSensor(state.sensor),
    };
  }

  Map<String, String> _buildStep2Fields(TambahFormState state, String nameFile) {
    return {
      'name_file': nameFile,
      'name_column[ID]': 'ID',
      'name_column[X]': 'easting',
      'name_column[Y]': 'northing',
      'name_column[band1]': 'Red',
      'name_column[band2]': 'Green',
      'name_column[band3]': 'NIR',
      'is_ganoderma': _yesNoToBoolString(state.ganodermaStep3),
    };
  }

  Map<String, String> _buildStep3Fields(
    TambahFormState state, {
    required String filename,
    required String locationFilename,
    required String mapFilename,
    required bool isKcd,
  }) {
    return {
      'filename': filename,
      'location_filename': locationFilename,
      'map_filename': mapFilename,
      'project_name': state.namaProjek.trim(),
      'customer_name': state.namaPerusahaan.trim(),
      'plantation_name': state.namaKebun.trim(),
      'company_name': state.namaPerusahaan.trim(),
      'customer_address': state.detailLokasi.trim(),
      'date': _toApiDate(state.tanggalAnalisis),
      'collection_date': _toApiDate(state.tanggalPengambilan),
      'location': state.detailLokasi.trim(),
      'location_province': state.selectedProvinsi?.name.toUpperCase() ?? '',
      'location_city': state.selectedKabupaten?.name.toUpperCase() ?? '',
      'location_subdistrict': state.selectedKecamatan?.name.toUpperCase() ?? '',
      'sensor_type': _normalizeSensor(state.sensor),
      'is_kcd': isKcd ? '1' : '0',
      'txt_id': 'ID',
      'txt_x': 'easting',
      'txt_y': 'northing',
      'txt_band_red': 'Red',
      'txt_band_green': 'Green',
      'txt_band_nir': 'NIR',

      // Field tambahan sesuai error SQL fertilizer_recommendations.
      'planting_year': state.tahunTanam.trim(),
      'block_number': state.blok.trim(),
      'kcd': state.nomorKcd.trim(),
      'land_area': _normalizeDecimal(state.luasHa),
      'number_of_trees': state.jumlahPohonHa.trim(),
      'annual_tree_productivity': _normalizeDecimal(state.protas),
      'soil_n': _optionalDecimal(state.nilaiNStep2),
      'soil_p': _optionalDecimal(state.nilaiPStep2),
      'soil_k': _optionalDecimal(state.nilaiKStep2),
      'soil_ca': _optionalDecimal(state.nilaiCaStep2),
      'soil_mg': _optionalDecimal(state.nilaiMgStep2),
      'status': 'submitted',
    };
  }

  bool _isAllowedFile(String value) {
    final lower = value.toLowerCase();
    return lower.endsWith('.csv') ||
        lower.endsWith('.xlsx') ||
        lower.endsWith('.xls');
  }

  bool _isText(String value) => value.trim().isNotEmpty;

  bool _isInt(String value) => int.tryParse(value.trim()) != null;

  bool _isDecimal(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.')) != null;
  }

  bool _isValidDate(String value) {
    final parts = value.trim().split('/');
    if (parts.length != 3) return false;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return false;
    if (year < 2020 || year > 2035) return false;

    final date = DateTime.tryParse(
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}',
    );

    return date != null &&
        date.day == day &&
        date.month == month &&
        date.year == year;
  }

  String _toApiDate(String value) {
    final parts = value.trim().split('/');
    if (parts.length != 3) return value.trim();

    return '${parts[2].padLeft(4, '0')}-'
        '${parts[1].padLeft(2, '0')}-'
        '${parts[0].padLeft(2, '0')}';
  }

  String _yesNoToBoolString(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'ya' ||
            normalized == 'yes' ||
            normalized == 'true'
        ? 'true'
        : 'false';
  }

  String _normalizeSensor(String value) {
    final sensor = value.trim();
    if (sensor.toLowerCase() == 'micasense') return 'Micasense';
    return sensor;
  }

  String _normalizeDecimal(String value) {
    return value.trim().replaceAll(',', '.');
  }

  String _optionalDecimal(String value) {
    final normalized = _normalizeDecimal(value);
    return normalized.isEmpty ? '0' : normalized;
  }

  String? _extractString(Map<String, dynamic> source, List<String> paths) {
    for (final path in paths) {
      dynamic current = source;

      for (final part in path.split('.')) {
        if (current is Map && current.containsKey(part)) {
          current = current[part];
        } else {
          current = null;
          break;
        }
      }

      if (current != null && current.toString().trim().isNotEmpty) {
        return current.toString();
      }
    }

    return null;
  }

  bool _extractBool(Map<String, dynamic> source, List<String> paths) {
    final value = _extractString(source, paths);
    if (value == null) return false;

    final normalized = value.trim().toLowerCase();

    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'ya';
  }

  _Step2TupleResult _parseStep2Tuple(String value) {
    final cleaned = value
        .trim()
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll("'", '');

    final parts = cleaned.split(',').map((e) => e.trim()).toList();

    return _Step2TupleResult(
      filename: parts.isNotEmpty ? parts[0] : null,
      locationFilename: parts.length > 1 ? parts[1] : null,
      mapFilename: parts.length > 2 ? parts[2] : null,
    );
  }
}

class _Step2TupleResult {
  final String? filename;
  final String? locationFilename;
  final String? mapFilename;

  const _Step2TupleResult({
    required this.filename,
    required this.locationFilename,
    required this.mapFilename,
  });
}
