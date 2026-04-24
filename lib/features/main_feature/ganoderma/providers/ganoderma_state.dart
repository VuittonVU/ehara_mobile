import '../models/ganoderma_model.dart';

class GanodermaState {
  final GanodermaModel? data;
  final bool isLoading;
  final String? errorMessage;

  const GanodermaState({
    required this.data,
    required this.isLoading,
    required this.errorMessage,
  });

  factory GanodermaState.initial() {
    return const GanodermaState(
      data: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  GanodermaState copyWith({
    GanodermaModel? data,
    bool clearData = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return GanodermaState(
      data: clearData ? null : (data ?? this.data),
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
      clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}