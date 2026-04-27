enum KebunSortType {
  terbaru,
  terlama,
  az,
  za,
}

class KebunFilterModel {
  final DateTime? startAnalysisDate;
  final DateTime? endAnalysisDate;
  final DateTime? startPickupDate;
  final DateTime? endPickupDate;
  final KebunSortType? sortType;

  const KebunFilterModel({
    this.startAnalysisDate,
    this.endAnalysisDate,
    this.startPickupDate,
    this.endPickupDate,
    this.sortType,
  });

  bool get hasActiveFilter {
    return startAnalysisDate != null ||
        endAnalysisDate != null ||
        startPickupDate != null ||
        endPickupDate != null ||
        sortType != null;
  }

  static const empty = KebunFilterModel();
}