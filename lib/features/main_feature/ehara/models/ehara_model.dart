class EHaraModel {
  final String eHaraUuid;
  final String estateName;
  final String certificateNumber;
  final String analysisDate;
  final String location;
  final int totalTrees;
  final String sensorType;
  final double nValue;
  final double pValue;
  final double kValue;
  final double mgValue;
  final bool hasData;

  // map backend
  final String mapFilename;
  final String mapUrl;

  const EHaraModel({
    required this.eHaraUuid,
    required this.estateName,
    required this.certificateNumber,
    required this.analysisDate,
    required this.location,
    required this.totalTrees,
    required this.sensorType,
    required this.nValue,
    required this.pValue,
    required this.kValue,
    required this.mgValue,
    required this.hasData,
    required this.mapFilename,
    required this.mapUrl,
  });

  factory EHaraModel.fromApi(Map<String, dynamic> json) {
    final root = _extractNestedData(json);

    final eHara = root['e_hara'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(root['e_hara'])
        : <String, dynamic>{};

    final filename = _readString(
      eHara,
      ['map_filename'],
    );

    final urlFromResponse = _readString(
      eHara,
      [
        'map_url',
        'map_image_url',
        'map_preview_url',
        'map_full_url',
      ],
    );

    return EHaraModel(
      eHaraUuid: _readString(
        eHara,
        ['uuid', 'e_hara_uuid', 'id'],
      ),
      estateName: _readString(
        eHara,
        ['plantation_name', 'project_name', 'estate_name', 'name'],
        fallback: '-',
      ),
      certificateNumber: _readString(
        eHara,
        ['certificate_number', 'no_sertifikat', 'certificate_no'],
        fallback: '-',
      ),
      analysisDate: _readString(
        eHara,
        ['date', 'analysis_date', 'tanggal_analisis'],
        fallback: '-',
      ),
      location: _readString(
        eHara,
        ['location', 'alamat', 'address'],
        fallback: '-',
      ),
      totalTrees: _readInt(
        root,
        ['tot_rows', 'total_rows', 'total_pohon', 'jumlah_pohon'],
      ),
      sensorType: _readString(
        root,
        ['sensor_type', 'jenis_sensor', 'sensor'],
        fallback: '-',
      ),
      nValue: _readDouble(
        root,
        ['predicted_n', 'n', 'nitrogen'],
      ),
      pValue: _readDouble(
        root,
        ['predicted_p', 'p', 'phosphor', 'phosphorus'],
      ),
      kValue: _readDouble(
        root,
        ['predicted_k', 'k', 'kalium', 'potassium'],
      ),
      mgValue: _readDouble(
        root,
        ['predicted_mg', 'mg', 'magnesium'],
      ),
      hasData: _readBool(root, ['has_data']),
      mapFilename: filename,
      mapUrl: urlFromResponse,
    );
  }

  static Map<String, dynamic> _extractNestedData(Map<String, dynamic> json) {
    dynamic current = json;

    while (current is Map<String, dynamic>) {
      if (current['data'] is Map<String, dynamic>) {
        current = current['data'];
      } else {
        break;
      }
    }

    return current is Map<String, dynamic> ? current : <String, dynamic>{};
  }

  static String _readString(
      Map<String, dynamic> map,
      List<String> keys, {
        String fallback = '',
      }) {
    for (final key in keys) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  static int _readInt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return 0;
  }

  static double _readDouble(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return 0;
  }

  static bool _readBool(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true' || lower == '1') return true;
        if (lower == 'false' || lower == '0') return false;
      }
    }
    return false;
  }
}