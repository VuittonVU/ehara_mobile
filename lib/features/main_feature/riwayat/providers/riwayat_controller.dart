import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/riwayat_model.dart';
import '../services/riwayat_service.dart';
import 'riwayat_state.dart';

final riwayatServiceProvider = Provider<RiwayatService>(
      (ref) => RiwayatService(),
);

final riwayatControllerProvider =
StateNotifierProvider<RiwayatController, RiwayatState>(
      (ref) => RiwayatController(
    riwayatService: ref.read(riwayatServiceProvider),
  )..loadRiwayat(),
);

class RiwayatController extends StateNotifier<RiwayatState> {
  final RiwayatService riwayatService;

  RiwayatController({
    required this.riwayatService,
  }) : super(RiwayatState.initial());

  Future<void> loadRiwayat() async {
    try {
      state = state.copyWith(
        viewState: RiwayatViewState.loading,
        clearErrorMessage: true,
      );

      final data = await riwayatService.getRiwayatList();

      if (data.isEmpty) {
        state = state.copyWith(
          viewState: RiwayatViewState.empty,
          allItems: [],
          filteredItems: [],
        );
        return;
      }

      final filtered = _applyFilters(
        source: data,
        startDate: state.startDate,
        endDate: state.endDate,
        sortType: state.sortType,
      );

      state = state.copyWith(
        viewState:
        filtered.isEmpty ? RiwayatViewState.empty : RiwayatViewState.success,
        allItems: data,
        filteredItems: filtered,
      );
    } catch (e) {
      state = state.copyWith(
        viewState: RiwayatViewState.error,
        errorMessage: e.toString(),
      );
    }
  }

  void applyFilter({
    required DateTime? startDate,
    required DateTime? endDate,
    required RiwayatSortType? sortType,
  }) {
    final filtered = _applyFilters(
      source: state.allItems,
      startDate: startDate,
      endDate: endDate,
      sortType: sortType,
    );

    state = state.copyWith(
      startDate: startDate,
      clearStartDate: startDate == null,
      endDate: endDate,
      clearEndDate: endDate == null,
      sortType: sortType,
      clearSortType: sortType == null,
      filteredItems: filtered,
      viewState:
      filtered.isEmpty ? RiwayatViewState.empty : RiwayatViewState.success,
    );
  }

  void resetFilter() {
    final filtered = _applyFilters(
      source: state.allItems,
      startDate: null,
      endDate: null,
      sortType: null,
    );

    state = state.copyWith(
      clearStartDate: true,
      clearEndDate: true,
      clearSortType: true,
      filteredItems: filtered,
      viewState:
      filtered.isEmpty ? RiwayatViewState.empty : RiwayatViewState.success,
    );
  }

  List<RiwayatModel> _applyFilters({
    required List<RiwayatModel> source,
    required DateTime? startDate,
    required DateTime? endDate,
    required RiwayatSortType? sortType,
  }) {
    var result = List<RiwayatModel>.from(source);

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

    if (sortType != null) {
      switch (sortType) {
        case RiwayatSortType.newest:
          result.sort((a, b) => b.date.compareTo(a.date));
          break;
        case RiwayatSortType.oldest:
          result.sort((a, b) => a.date.compareTo(b.date));
          break;
        case RiwayatSortType.az:
          result.sort((a, b) => a.projectName.compareTo(b.projectName));
          break;
        case RiwayatSortType.za:
          result.sort((a, b) => b.projectName.compareTo(a.projectName));
          break;
      }
    }

    return result;
  }
}