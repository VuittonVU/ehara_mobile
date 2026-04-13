class SertifikatModel {
  final String projectName;
  final DateTime date;
  final String farmName;
  final String eHaraCertificateNumber;
  final String ganomonCertificateNumber;
  final bool isPublished;

  const SertifikatModel({
    required this.projectName,
    required this.date,
    required this.farmName,
    required this.eHaraCertificateNumber,
    required this.ganomonCertificateNumber,
    required this.isPublished,
  });
}