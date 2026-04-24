class RiwayatModel {
  final String id;
  final String eHaraUuid;
  final String projectName;
  final DateTime date;
  final String farmName;

  const RiwayatModel({
    required this.id,
    required this.eHaraUuid,
    required this.projectName,
    required this.date,
    required this.farmName,
  });

  factory RiwayatModel.fromMap(Map<String, dynamic> map) {
    String readString(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = map[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return fallback;
    }

    DateTime readDate(List<String> keys) {
      for (final key in keys) {
        final value = map[key];
        if (value == null) continue;

        final text = value.toString().trim();
        if (text.isEmpty) continue;

        final parsed = DateTime.tryParse(text);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    return RiwayatModel(
      id: readString(['id', 'value_id', 'row_id'], fallback: '0'),
      eHaraUuid: readString(['uuid', 'e_hara_uuid'], fallback: ''),
      projectName: readString(
        ['project_name', 'nama_proyek', 'customer_name', 'company_name'],
        fallback: '-',
      ),
      date: readDate(['date', 'analysis_date', 'tanggal_analisis', 'created_at']),
      farmName: readString(
        ['plantation_name', 'nama_kebun', 'farm_name', 'estate_name'],
        fallback: '-',
      ),
    );
  }
}