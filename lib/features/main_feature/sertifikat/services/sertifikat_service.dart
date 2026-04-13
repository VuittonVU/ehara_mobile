import '../models/sertifikat_model.dart';

class SertifikatService {
  Future<List<SertifikatModel>> getCertificates() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      SertifikatModel(
        projectName: 'Projek Nusantara',
        date: DateTime(2026, 3, 9),
        farmName: 'Kwala Sawit',
        eHaraCertificateNumber: 'EH/001/III/2026',
        ganomonCertificateNumber: 'GN/001/III/2026',
        isPublished: true,
      ),
      SertifikatModel(
        projectName: 'Projek Nusantara',
        date: DateTime(2026, 3, 8),
        farmName: 'Kwala Sawit',
        eHaraCertificateNumber: 'EH/002/III/2026',
        ganomonCertificateNumber: 'GN/002/III/2026',
        isPublished: true,
      ),
      SertifikatModel(
        projectName: 'Projek Nusantara',
        date: DateTime(2026, 3, 7),
        farmName: 'Kwala Sawit',
        eHaraCertificateNumber: 'Belum Terbit',
        ganomonCertificateNumber: 'Belum Terbit',
        isPublished: false,
      ),
    ];
  }
}