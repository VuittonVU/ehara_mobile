class RiwayatModel {
  final String id;
  final String projectName;
  final DateTime date;
  final String farmName;
  final bool isPublished;

  const RiwayatModel({
    required this.id,
    required this.projectName,
    required this.date,
    required this.farmName,
    required this.isPublished,
  });
}