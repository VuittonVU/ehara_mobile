import '../models/hitung_pohon_job_model.dart';

class HitungPohonState {
  final bool isLoading;
  final bool isUploading;
  final String? errorMessage;
  final HitungPohonJobModel? currentJob;
  final List<HitungPohonJobModel> history;

  const HitungPohonState({
    required this.isLoading,
    required this.isUploading,
    required this.errorMessage,
    required this.currentJob,
    required this.history,
  });

  factory HitungPohonState.initial() {
    return const HitungPohonState(
      isLoading: false,
      isUploading: false,
      errorMessage: null,
      currentJob: null,
      history: [],
    );
  }

  HitungPohonState copyWith({
    bool? isLoading,
    bool? isUploading,
    String? errorMessage,
    bool clearError = false,
    HitungPohonJobModel? currentJob,
    bool clearCurrentJob = false,
    List<HitungPohonJobModel>? history,
  }) {
    return HitungPohonState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentJob: clearCurrentJob ? null : currentJob ?? this.currentJob,
      history: history ?? this.history,
    );
  }
}
