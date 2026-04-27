class GanodermaPointModel {
  final int pointNo;
  final String status;
  final double rawX;
  final double rawY;

  const GanodermaPointModel({
    required this.pointNo,
    required this.status,
    required this.rawX,
    required this.rawY,
  });

  bool get isDetected => status.toLowerCase() != 'sehat';

  double get displayX => rawY;
  double get displayY => rawX;

  factory GanodermaPointModel.fromApi(Map<String, dynamic> json) {
    final value = json['value'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['value'])
        : <String, dynamic>{};

    return GanodermaPointModel(
      pointNo: _readInt(json, ['value_id', 'id']),
      status: json['rf_ap']?.toString() ?? 'Unknown',
      rawX: _readDouble(value, ['x']),
      rawY: _readDouble(value, ['y']),
    );
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
}

class GanodermaModel {
  static const String _baseS3Url =
      'https://iopri-storage-prod-ap-southeast-1-001.s3.ap-southeast-1.amazonaws.com/';

  final String eHaraUuid;
  final String namaKebun;
  final String tanggalAnalisis;
  final String lokasi;
  final String tahunTanam;
  final String nomorBlok;
  final String luasHa;
  final String produktivitasTahunan;
  final String jumlahPohonPerHa;
  final String nomorKcd;
  final String sertifikat;
  final String? csvUrl;

  final int totalPoints;
  final int detectedCount;
  final int healthyCount;
  final List<GanodermaPointModel> points;

  const GanodermaModel({
    required this.eHaraUuid,
    required this.namaKebun,
    required this.tanggalAnalisis,
    required this.lokasi,
    required this.tahunTanam,
    required this.nomorBlok,
    required this.luasHa,
    required this.produktivitasTahunan,
    required this.jumlahPohonPerHa,
    required this.nomorKcd,
    required this.sertifikat,
    required this.csvUrl,
    required this.totalPoints,
    required this.detectedCount,
    required this.healthyCount,
    required this.points,
  });

  factory GanodermaModel.fromApi({
    required List<dynamic> ganodermaRows,
    Map<String, dynamic>? recommendationJson,
    String? csvUrl,
  }) {
    final rows = ganodermaRows
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (rows.isEmpty) {
      return GanodermaModel(
        eHaraUuid: '',
        namaKebun: '-',
        tanggalAnalisis: '-',
        lokasi: '-',
        tahunTanam: '-',
        nomorBlok: '-',
        luasHa: '-',
        produktivitasTahunan: '-',
        jumlahPohonPerHa: '-',
        nomorKcd: '-',
        sertifikat: '-',
        csvUrl: csvUrl,
        totalPoints: 0,
        detectedCount: 0,
        healthyCount: 0,
        points: const [],
      );
    }

    final first = rows.first;
    final eHara = first['e_hara'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(first['e_hara'])
        : <String, dynamic>{};

    final recommendation = _extractRecommendation(recommendationJson);
    final recEHara = recommendation['e_hara'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(recommendation['e_hara'])
        : <String, dynamic>{};

    final points = rows.map(GanodermaPointModel.fromApi).toList();
    final detectedCount = points.where((e) => e.isDetected).length;
    final healthyCount = points.where((e) => !e.isDetected).length;

    return GanodermaModel(
      eHaraUuid: _readString(
        first,
        ['e_hara_uuid'],
        fallback: _readString(eHara, ['uuid']),
      ),
      namaKebun: _readString(
        eHara,
        ['plantation_name', 'project_name', 'estate_name', 'name'],
        fallback: _readString(
          recEHara,
          ['plantation_name', 'project_name', 'estate_name', 'name'],
          fallback: '-',
        ),
      ),
      tanggalAnalisis: _readString(
        eHara,
        ['date', 'analysis_date', 'tanggal_analisis'],
        fallback: _readString(
          recEHara,
          ['date', 'analysis_date', 'tanggal_analisis'],
          fallback: '-',
        ),
      ),
      lokasi: _readString(
        eHara,
        ['location', 'alamat', 'address'],
        fallback: _readString(
          recEHara,
          ['location', 'alamat', 'address'],
          fallback: '-',
        ),
      ),
      tahunTanam: _readString(
        recommendation,
        ['planting_year', 'tahun_tanam'],
        fallback: '-',
      ),
      nomorBlok: _readString(
        recommendation,
        ['block_number', 'nomor_blok', 'blok'],
        fallback: '-',
      ),
      luasHa: _readString(
        recommendation,
        ['land_area', 'luas_ha', 'area_ha'],
        fallback: '-',
      ),
      produktivitasTahunan: _readString(
        recommendation,
        ['annual_tree_productivity', 'produktivitas_tahunan'],
        fallback: '-',
      ),
      jumlahPohonPerHa: _readString(
        recommendation,
        ['number_of_trees', 'jumlah_pohon_per_ha', 'trees_per_ha'],
        fallback: _readString(
          eHara,
          ['total_rows', 'number_of_trees', 'jumlah_pohon_per_ha'],
          fallback: '-',
        ),
      ),
      nomorKcd: _readString(
        recommendation,
        ['kcd', 'nomor_kcd', 'kcd_number'],
        fallback: '-',
      ),
      sertifikat: _readString(
        eHara,
        ['certificate_number_ganoderma', 'certificate_number'],
        fallback: _readString(
          recEHara,
          ['certificate_number_ganoderma', 'certificate_number'],
          fallback: '-',
        ),
      ),
      csvUrl: csvUrl,
      totalPoints: points.length,
      detectedCount: detectedCount,
      healthyCount: healthyCount,
      points: points,
    );
  }

  static String? extractGanodermaCsvUrlFromDatatable({
    required List<dynamic> rows,
    required String eHaraUuid,
  }) {
    for (final row in rows) {
      if (row is! Map) continue;

      final map = Map<String, dynamic>.from(row);

      final uuid = _readString(
        map,
        ['uuid', 'e_hara_uuid'],
        fallback: _readNestedString(map, ['e_hara_transaction', 'e_hara_uuid']),
      );

      if (uuid != eHaraUuid) continue;

      final filename = _readString(
        map,
        ['filename_ganoderma', 'ganoderma_filename', 'csv_ganoderma'],
      );

      if (filename.isEmpty) return null;

      return _buildS3Url(filename);
    }

    return null;
  }

  static String _buildS3Url(String filename) {
    final clean = filename.trim();

    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return clean;
    }

    return '$_baseS3Url$clean';
  }

  static String _readNestedString(
      Map<String, dynamic> map,
      List<String> keys,
      ) {
    dynamic current = map;

    for (final key in keys) {
      if (current is Map && current[key] != null) {
        current = current[key];
      } else {
        return '';
      }
    }

    return current?.toString() ?? '';
  }

  static Map<String, dynamic> _extractRecommendation(
      Map<String, dynamic>? json,
      ) {
    if (json == null) return <String, dynamic>{};

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final fertilizer = data['fertilizer_recommendation'];
      if (fertilizer is Map<String, dynamic>) {
        return Map<String, dynamic>.from(fertilizer);
      }
    }

    return <String, dynamic>{};
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
}