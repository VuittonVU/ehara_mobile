import '../models/riwayat_model.dart';

enum RiwayatViewState {
  loading,
  success,
  empty,
  error,
}

enum RiwayatSortType {
  newest,
  oldest,
  az,
  za,
}

class RiwayatState {
  final RiwayatViewState viewState;
  final List<RiwayatModel> allItems;
  final List<RiwayatModel> filteredItems;
  final DateTime? startDate;
  final DateTime? endDate;
  final RiwayatSortType? sortType;
  final String? errorMessage;

  const RiwayatState({
    required this.viewState,
    required this.allItems,
    required this.filteredItems,
    required this.startDate,
    required this.endDate,
    required this.sortType,
    required this.errorMessage,
  });

  factory RiwayatState.initial() {
    return const RiwayatState(
      viewState: RiwayatViewState.loading,
      allItems: [],
      filteredItems: [],
      startDate: null,
      endDate: null,
      sortType: null,
      errorMessage: null,
    );
  }

  RiwayatState copyWith({
    RiwayatViewState? viewState,
    List<RiwayatModel>? allItems,
    List<RiwayatModel>? filteredItems,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    RiwayatSortType? sortType,
    bool clearSortType = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RiwayatState(
      viewState: viewState ?? this.viewState,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      sortType: clearSortType ? null : (sortType ?? this.sortType),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}