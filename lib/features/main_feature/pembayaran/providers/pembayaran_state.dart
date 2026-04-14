import '../models/pembayaran_filter_model.dart';
import '../models/pembayaran_model.dart';

enum PembayaranViewState {
  loading,
  success,
  empty,
  error,
}

class PembayaranState {
  final PembayaranViewState viewState;
  final List<PembayaranModel> allItems;
  final List<PembayaranModel> filteredItems;
  final PembayaranFilterModel filter;
  final String? errorMessage;

  const PembayaranState({
    required this.viewState,
    required this.allItems,
    required this.filteredItems,
    required this.filter,
    required this.errorMessage,
  });

  factory PembayaranState.initial() {
    return const PembayaranState(
      viewState: PembayaranViewState.loading,
      allItems: [],
      filteredItems: [],
      filter: PembayaranFilterModel.empty,
      errorMessage: null,
    );
  }

  PembayaranState copyWith({
    PembayaranViewState? viewState,
    List<PembayaranModel>? allItems,
    List<PembayaranModel>? filteredItems,
    PembayaranFilterModel? filter,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PembayaranState(
      viewState: viewState ?? this.viewState,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      filter: filter ?? this.filter,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}