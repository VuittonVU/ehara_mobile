class RekomendasiPemupukanModel {
  final String eHaraUuid;
  final String namaKebun;
  final String tanggalAnalisis;
  final String lokasi;

  final String tahunTanam;
  final String umurTanaman;
  final String nomorBlok;
  final String jumlahPohonPerHa;
  final String nomorKcd;
  final String luasHa;
  final String produktivitasTahunan;
  final String sertifikat;

  final double n;
  final double p;
  final double k;
  final double mg;

  final double nStandar;
  final double pStandar;
  final double kStandar;
  final double mgStandar;

  final List<RekomendasiDoseModel> dosis;

  const RekomendasiPemupukanModel({
    required this.eHaraUuid,
    required this.namaKebun,
    required this.tanggalAnalisis,
    required this.lokasi,
    required this.tahunTanam,
    required this.umurTanaman,
    required this.nomorBlok,
    required this.jumlahPohonPerHa,
    required this.nomorKcd,
    required this.luasHa,
    required this.produktivitasTahunan,
    required this.sertifikat,
    required this.n,
    required this.p,
    required this.k,
    required this.mg,
    required this.nStandar,
    required this.pStandar,
    required this.kStandar,
    required this.mgStandar,
    required this.dosis,
  });

  factory RekomendasiPemupukanModel.fromApi({
    required Map<String, dynamic> dashboardJson,
    required Map<String, dynamic> recommendationJson,
  }) {
    final dashRoot = _extractNestedData(dashboardJson);

    final recRoot = recommendationJson['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(recommendationJson['data'])
        : <String, dynamic>{};

    final fertilizer = recRoot['fertilizer_recommendation'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(recRoot['fertilizer_recommendation'])
        : <String, dynamic>{};

    final eHara = fertilizer['e_hara'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(fertilizer['e_hara'])
        : (dashRoot['e_hara'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(dashRoot['e_hara'])
        : <String, dynamic>{});

    return RekomendasiPemupukanModel(
      eHaraUuid: _readString(
        fertilizer,
        ['e_hara_uuid'],
        fallback: _readString(eHara, ['uuid', 'e_hara_uuid', 'id']),
      ),
      namaKebun: _readString(
        eHara,
        ['plantation_name', 'project_name', 'estate_name', 'name'],
        fallback: '-',
      ),
      tanggalAnalisis: _readString(
        eHara,
        ['date', 'analysis_date', 'tanggal_analisis'],
        fallback: '-',
      ),
      lokasi: _readString(
        eHara,
        ['location', 'alamat', 'address'],
        fallback: '-',
      ),
      tahunTanam: _readString(
        fertilizer,
        ['planting_year', 'tahun_tanam'],
        fallback: '-',
      ),
      umurTanaman: _readString(
        fertilizer,
        ['age', 'umur_tanaman'],
        fallback: '-',
      ),
      nomorBlok: _readString(
        fertilizer,
        ['block_number', 'nomor_blok', 'blok'],
        fallback: '-',
      ),
      jumlahPohonPerHa: _readString(
        fertilizer,
        ['number_of_trees', 'jumlah_pohon_per_ha', 'trees_per_ha'],
        fallback: '-',
      ),
      nomorKcd: _readString(
        fertilizer,
        ['kcd', 'nomor_kcd', 'kcd_number'],
        fallback: '-',
      ),
      luasHa: _readString(
        fertilizer,
        ['land_area', 'luas_ha', 'area_ha'],
        fallback: '-',
      ),
      produktivitasTahunan: _readString(
        fertilizer,
        ['annual_tree_productivity', 'produktivitas_tahunan'],
        fallback: '-',
      ),
      sertifikat: _readString(
        eHara,
        ['certificate_number', 'no_sertifikat', 'certificate_no'],
        fallback: '-',
      ),
      n: _readDouble(dashRoot, ['predicted_n', 'n']),
      p: _readDouble(dashRoot, ['predicted_p', 'p']),
      k: _readDouble(dashRoot, ['predicted_k', 'k']),
      mg: _readDouble(dashRoot, ['predicted_mg', 'mg']),

      // ikut web
      nStandar: 0.19,
      pStandar: 1.10,
      kStandar: 0.70,
      mgStandar: 0.30,

      dosis: _extractDoseList(fertilizer),
    );
  }

  static List<RekomendasiDoseModel> _extractDoseList(
      Map<String, dynamic> fertilizer,
      ) {
    final rawValues = fertilizer['fertilizer_recommendation_values'];

    if (rawValues is! List) {
      return const [];
    }

    final rows = rawValues
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (rows.isEmpty) {
      return const [];
    }

    return [
      _buildDoseItem(
        title: 'Urea',
        rows: rows,
        keys: const ['urea'],
      ),
      _buildDoseItem(
        title: 'TSP',
        rows: rows,
        keys: const ['tsp'],
      ),
      _buildDoseItem(
        title: 'MSP',
        rows: rows,
        keys: const ['mop'],
      ),
      _buildDoseItem(
        title: 'Dolomit',
        rows: rows,
        keys: const ['dolomit', 'dolomit2'],
      ),
    ];
  }

  static RekomendasiDoseModel _buildDoseItem({
    required String title,
    required List<Map<String, dynamic>> rows,
    required List<String> keys,
  }) {
    final values = <double>[];

    for (final row in rows) {
      for (final key in keys) {
        final value = _toDouble(row[key]);
        if (value != null) {
          values.add(value);
          break;
        }
      }
    }

    if (values.isEmpty) {
      return RekomendasiDoseModel(
        title: title,
        minimum: '0',
        maksimum: '0',
      );
    }

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return RekomendasiDoseModel(
      title: title,
      minimum: _formatNumber(minValue),
      maksimum: _formatNumber(maxValue),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String _formatNumber(double value) {
    return value.toStringAsFixed(2);
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

  static double _readDouble(
      Map<String, dynamic> map,
      List<String> keys, {
        double fallback = 0,
      }) {
    for (final key in keys) {
      final value = map[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return fallback;
  }
}

class RekomendasiDoseModel {
  final String title;
  final String minimum;
  final String maksimum;

  const RekomendasiDoseModel({
    required this.title,
    required this.minimum,
    required this.maksimum,
  });
}