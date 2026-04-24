import '../models/rekomendasi_pemupukan_model.dart';

class RekomendasiPemupukanState {
  final RekomendasiPemupukanModel? data;
  final bool isLoading;
  final String? errorMessage;

  const RekomendasiPemupukanState({
    required this.data,
    required this.isLoading,
    required this.errorMessage,
  });

  factory RekomendasiPemupukanState.initial() {
    return const RekomendasiPemupukanState(
      data: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  RekomendasiPemupukanState copyWith({
    RekomendasiPemupukanModel? data,
    bool clearData = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RekomendasiPemupukanState(
      data: clearData ? null : (data ?? this.data),
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
      clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}