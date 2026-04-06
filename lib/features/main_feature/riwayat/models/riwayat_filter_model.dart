enum RiwayatSortOption {
  terbaru,
  terlama,
  az,
  za,
}

enum RiwayatCertificateFilter {
  semua,
  sudahTerbit,
  belumTerbit,
}

class RiwayatFilterModel {
  final DateTime? startDate;
  final DateTime? endDate;
  final RiwayatSortOption sortOption;
  final RiwayatCertificateFilter certificateFilter;

  const RiwayatFilterModel({
    this.startDate,
    this.endDate,
    this.sortOption = RiwayatSortOption.terbaru,
    this.certificateFilter = RiwayatCertificateFilter.semua,
  });

  RiwayatFilterModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    RiwayatSortOption? sortOption,
    RiwayatCertificateFilter? certificateFilter,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return RiwayatFilterModel(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      sortOption: sortOption ?? this.sortOption,
      certificateFilter: certificateFilter ?? this.certificateFilter,
    );
  }

  bool get hasActiveFilter =>
      startDate != null ||
          endDate != null ||
          sortOption != RiwayatSortOption.terbaru ||
          certificateFilter != RiwayatCertificateFilter.semua;

  static const RiwayatFilterModel initial = RiwayatFilterModel();
}