import '../models/ehara_model.dart';

class EHaraState {
  final EHaraModel? dashboard;
  final bool isLoading;
  final String? errorMessage;

  const EHaraState({
    required this.dashboard,
    required this.isLoading,
    required this.errorMessage,
  });

  factory EHaraState.initial() {
    return const EHaraState(
      dashboard: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  EHaraState copyWith({
    EHaraModel? dashboard,
    bool clearDashboard = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return EHaraState(
      dashboard: clearDashboard ? null : (dashboard ?? this.dashboard),
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
      clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}