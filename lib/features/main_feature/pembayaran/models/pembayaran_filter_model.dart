import 'pembayaran_model.dart';

enum PembayaranSortType {
  terbaru,
  terlama,
  az,
  za,
}

class PembayaranFilterModel {
  final DateTime? startDate;
  final DateTime? endDate;
  final PembayaranSortType sortType;
  final PembayaranStatus? status;

  const PembayaranFilterModel({
    this.startDate,
    this.endDate,
    this.sortType = PembayaranSortType.terbaru,
    this.status,
  });

  PembayaranFilterModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
    PembayaranSortType? sortType,
    PembayaranStatus? status,
    bool clearStatus = false,
  }) {
    return PembayaranFilterModel(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      sortType: sortType ?? this.sortType,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasActiveFilter {
    return startDate != null || endDate != null || status != null;
  }

  static const empty = PembayaranFilterModel();
}