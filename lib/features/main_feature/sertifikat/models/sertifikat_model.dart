class SertifikatModel {
  final String projectName;
  final DateTime date;
  final String farmName;

  final String eHaraCertificateNumber;
  final String ganomonCertificateNumber;

  final String? eHaraPdfFilename;
  final String? ganomonPdfFilename;

  final bool isPublished;

  const SertifikatModel({
    required this.projectName,
    required this.date,
    required this.farmName,
    required this.eHaraCertificateNumber,
    required this.ganomonCertificateNumber,
    required this.eHaraPdfFilename,
    required this.ganomonPdfFilename,
    required this.isPublished,
  });

  bool get hasEHarapdf =>
      eHaraPdfFilename != null && eHaraPdfFilename!.trim().isNotEmpty;

  bool get hasGanomonPdf =>
      ganomonPdfFilename != null && ganomonPdfFilename!.trim().isNotEmpty;

  factory SertifikatModel.fromMap(Map<String, dynamic> map) {
    String clean(String? value) {
      if (value == null) return '-';
      return value.replaceAll(RegExp(r'[`´]+$'), '').trim();
    }

    DateTime parseDate() {
      final candidates = [
        map['date'],
        map['ehara_certificate']?['certificate_date'],
        map['ganomon_certificate']?['certificate_date'],
        map['created_at'],
      ];

      for (final value in candidates) {
        if (value == null) continue;
        final parsed = DateTime.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    String readCertificateNumber({
      required dynamic topLevelValue,
      required dynamic nestedValue,
    }) {
      final top = topLevelValue?.toString().trim() ?? '';
      if (top.isNotEmpty) return top;

      final nested = nestedValue?.toString().trim() ?? '';
      if (nested.isNotEmpty) return nested;

      return 'Belum Terbit';
    }

    final eharaCert = map['ehara_certificate'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(map['ehara_certificate'])
        : <String, dynamic>{};

    final ganomonCert = map['ganomon_certificate'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(map['ganomon_certificate'])
        : <String, dynamic>{};

    final eHaraFilename = eharaCert['filename']?.toString();
    final ganomonFilename = ganomonCert['filename']?.toString();

    final hasAnyPublishedPdf =
        (eharaCert['status'] == 'published' &&
            (eHaraFilename ?? '').trim().isNotEmpty) ||
            (ganomonCert['status'] == 'published' &&
                (ganomonFilename ?? '').trim().isNotEmpty);

    return SertifikatModel(
      projectName: clean(map['project_name']?.toString()),
      date: parseDate(),
      farmName: clean(map['plantation_name']?.toString()),
      eHaraCertificateNumber: readCertificateNumber(
        topLevelValue: map['certificate_number'],
        nestedValue: eharaCert['certificate_number'],
      ),
      ganomonCertificateNumber: readCertificateNumber(
        topLevelValue: map['certificate_number_ganoderma'],
        nestedValue: ganomonCert['certificate_number'],
      ),
      eHaraPdfFilename:
      (eHaraFilename != null && eHaraFilename.trim().isNotEmpty)
          ? eHaraFilename
          : null,
      ganomonPdfFilename:
      (ganomonFilename != null && ganomonFilename.trim().isNotEmpty)
          ? ganomonFilename
          : null,
      isPublished: hasAnyPublishedPdf,
    );
  }
}