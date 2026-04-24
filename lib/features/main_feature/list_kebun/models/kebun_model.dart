class KebunModel {
  final String id;
  final String eHaraUuid;
  final String namaKebun;
  final int totalPohon;
  final DateTime? tanggalAnalisis;
  final DateTime? tanggalPengambilanData;
  final String nomorSertifikat;

  const KebunModel({
    required this.id,
    required this.eHaraUuid,
    required this.namaKebun,
    required this.totalPohon,
    required this.tanggalAnalisis,
    required this.tanggalPengambilanData,
    required this.nomorSertifikat,
  });

  factory KebunModel.fromApi(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    String readString(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = json[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return fallback;
    }

    int readInt(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value is int) return value;
        if (value is double) return value.toInt();
        if (value is String) {
          final parsed = int.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
      return 0;
    }

    final uuid = readString([
      'e_hara_uuid',
      'uuid',
      'ehara_uuid',
    ]);

    return KebunModel(
      id: readString(['id'], fallback: uuid),
      eHaraUuid: uuid,
      namaKebun: readString(
        [
          'plantation_name',
          'project_name',
          'nama_kebun',
          'estate_name',
          'kebun',
          'name',
        ],
        fallback: '-',
      ),
      totalPohon: readInt([
        'total_rows',
        'total_pohon',
        'jumlah_pohon',
      ]),
      tanggalAnalisis: parseDate(
        json['date'],
      ),
      tanggalPengambilanData: parseDate(
        json['tanggal_pengambilan'] ??
            json['tanggal_pengambilan_data'] ??
            json['capture_date'],
      ),
      nomorSertifikat: readString(
        [
          'certificate_number',
          'no_sertifikat',
          'certificate_no',
        ],
        fallback: '-',
      ),
    );
  }
}