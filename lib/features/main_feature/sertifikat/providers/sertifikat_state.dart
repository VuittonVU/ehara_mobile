import '../models/sertifikat_model.dart';

enum SertifikatViewState {
  loading,
  success,
  empty,
  error,
}

enum SertifikatSortType {
  newest,
  oldest,
  az,
  za,
}

class SertifikatState {
  final SertifikatViewState viewState;
  final List<SertifikatModel> allCertificates;
  final List<SertifikatModel> filteredCertificates;
  final DateTime? startDate;
  final DateTime? endDate;
  final SertifikatSortType? sortType;
  final bool? publishedStatus;
  final String? errorMessage;

  const SertifikatState({
    required this.viewState,
    required this.allCertificates,
    required this.filteredCertificates,
    required this.startDate,
    required this.endDate,
    required this.sortType,
    required this.publishedStatus,
    required this.errorMessage,
  });

  factory SertifikatState.initial() {
    return const SertifikatState(
      viewState: SertifikatViewState.loading,
      allCertificates: [],
      filteredCertificates: [],
      startDate: null,
      endDate: null,
      sortType: null,
      publishedStatus: null,
      errorMessage: null,
    );
  }

  SertifikatState copyWith({
    SertifikatViewState? viewState,
    List<SertifikatModel>? allCertificates,
    List<SertifikatModel>? filteredCertificates,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    SertifikatSortType? sortType,
    bool clearSortType = false,
    bool? publishedStatus,
    bool clearPublishedStatus = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SertifikatState(
      viewState: viewState ?? this.viewState,
      allCertificates: allCertificates ?? this.allCertificates,
      filteredCertificates: filteredCertificates ?? this.filteredCertificates,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      sortType: clearSortType ? null : (sortType ?? this.sortType),
      publishedStatus: clearPublishedStatus
          ? null
          : (publishedStatus ?? this.publishedStatus),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}