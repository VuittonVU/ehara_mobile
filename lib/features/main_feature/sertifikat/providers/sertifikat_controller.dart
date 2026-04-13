import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sertifikat_model.dart';
import '../services/sertifikat_service.dart';
import 'sertifikat_state.dart';

final sertifikatServiceProvider = Provider<SertifikatService>(
      (ref) => SertifikatService(),
);

final sertifikatControllerProvider =
StateNotifierProvider<SertifikatController, SertifikatState>(
      (ref) => SertifikatController(
    sertifikatService: ref.read(sertifikatServiceProvider),
  )..loadCertificates(),
);

class SertifikatController extends StateNotifier<SertifikatState> {
  final SertifikatService sertifikatService;

  SertifikatController({
    required this.sertifikatService,
  }) : super(SertifikatState.initial());

  Future<void> loadCertificates() async {
    try {
      state = state.copyWith(
        viewState: SertifikatViewState.loading,
        clearErrorMessage: true,
      );

      final data = await sertifikatService.getCertificates();

      if (data.isEmpty) {
        state = state.copyWith(
          viewState: SertifikatViewState.empty,
          allCertificates: [],
          filteredCertificates: [],
        );
        return;
      }

      final filtered = _applyFilters(
        source: data,
        startDate: state.startDate,
        endDate: state.endDate,
        sortType: state.sortType,
        publishedStatus: state.publishedStatus,
      );

      state = state.copyWith(
        viewState: filtered.isEmpty
            ? SertifikatViewState.empty
            : SertifikatViewState.success,
        allCertificates: data,
        filteredCertificates: filtered,
      );
    } catch (e) {
      state = state.copyWith(
        viewState: SertifikatViewState.error,
        errorMessage: e.toString(),
      );
    }
  }

  void applyFilter({
    required DateTime? startDate,
    required DateTime? endDate,
    required SertifikatSortType? sortType,
    required bool? publishedStatus,
  }) {
    final filtered = _applyFilters(
      source: state.allCertificates,
      startDate: startDate,
      endDate: endDate,
      sortType: sortType,
      publishedStatus: publishedStatus,
    );

    state = state.copyWith(
      startDate: startDate,
      clearStartDate: startDate == null,
      endDate: endDate,
      clearEndDate: endDate == null,
      sortType: sortType,
      clearSortType: sortType == null,
      publishedStatus: publishedStatus,
      clearPublishedStatus: publishedStatus == null,
      filteredCertificates: filtered,
      viewState:
      filtered.isEmpty ? SertifikatViewState.empty : SertifikatViewState.success,
    );
  }

  void resetFilter() {
    final filtered = _applyFilters(
      source: state.allCertificates,
      startDate: null,
      endDate: null,
      sortType: null,
      publishedStatus: null,
    );

    state = state.copyWith(
      clearStartDate: true,
      clearEndDate: true,
      clearSortType: true,
      clearPublishedStatus: true,
      filteredCertificates: filtered,
      viewState:
      filtered.isEmpty ? SertifikatViewState.empty : SertifikatViewState.success,
    );
  }

  List<SertifikatModel> _applyFilters({
    required List<SertifikatModel> source,
    required DateTime? startDate,
    required DateTime? endDate,
    required SertifikatSortType? sortType,
    required bool? publishedStatus,
  }) {
    var result = List<SertifikatModel>.from(source);

    if (startDate != null) {
      final normalizedStart = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );

      result = result.where((item) {
        final itemDate = DateTime(item.date.year, item.date.month, item.date.day);
        return !itemDate.isBefore(normalizedStart);
      }).toList();
    }

    if (endDate != null) {
      final normalizedEnd = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
      );

      result = result.where((item) {
        final itemDate = DateTime(item.date.year, item.date.month, item.date.day);
        return !itemDate.isAfter(normalizedEnd);
      }).toList();
    }

    if (publishedStatus != null) {
      result = result
          .where((item) => item.isPublished == publishedStatus)
          .toList();
    }

    if (sortType != null) {
      switch (sortType) {
        case SertifikatSortType.newest:
          result.sort((a, b) => b.date.compareTo(a.date));
          break;
        case SertifikatSortType.oldest:
          result.sort((a, b) => a.date.compareTo(b.date));
          break;
        case SertifikatSortType.az:
          result.sort((a, b) => a.projectName.compareTo(b.projectName));
          break;
        case SertifikatSortType.za:
          result.sort((a, b) => b.projectName.compareTo(a.projectName));
          break;
      }
    }

    return result;
  }
}