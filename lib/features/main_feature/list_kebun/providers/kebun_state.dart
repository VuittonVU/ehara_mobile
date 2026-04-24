import '../models/kebun_model.dart';

class KebunState {
  final List<KebunModel> list;
  final bool isLoading;
  final String? errorMessage;

  const KebunState({
    required this.list,
    required this.isLoading,
    required this.errorMessage,
  });

  factory KebunState.initial() {
    return const KebunState(
      list: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  KebunState copyWith({
    List<KebunModel>? list,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return KebunState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}