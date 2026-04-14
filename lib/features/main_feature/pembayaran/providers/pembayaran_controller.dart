import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pembayaran_filter_model.dart';
import '../models/pembayaran_model.dart';
import '../services/pembayaran_service.dart';
import 'pembayaran_state.dart';

final pembayaranServiceProvider = Provider<PembayaranService>(
      (ref) => PembayaranService(),
);

final pembayaranControllerProvider =
StateNotifierProvider<PembayaranController, PembayaranState>(
      (ref) => PembayaranController(
    pembayaranService: ref.read(pembayaranServiceProvider),
  )..loadPembayaran(),
);

class PembayaranController extends StateNotifier<PembayaranState> {
  final PembayaranService pembayaranService;

  PembayaranController({
    required this.pembayaranService,
  }) : super(PembayaranState.initial());

  Future<void> loadPembayaran() async {
    try {
      state = state.copyWith(
        viewState: PembayaranViewState.loading,
        clearErrorMessage: true,
      );

      final data = await pembayaranService.getPembayaranList();

      if (data.isEmpty) {
        state = state.copyWith(
          viewState: PembayaranViewState.empty,
          allItems: [],
          filteredItems: [],
        );
        return;
      }

      final filtered = _applyFilters(
        source: data,
        filter: state.filter,
      );

      state = state.copyWith(
        viewState: filtered.isEmpty
            ? PembayaranViewState.empty
            : PembayaranViewState.success,
        allItems: data,
        filteredItems: filtered,
      );
    } catch (e) {
      state = state.copyWith(
        viewState: PembayaranViewState.error,
        errorMessage: e.toString(),
      );
    }
  }

  void applyFilter(PembayaranFilterModel filter) {
    final filtered = _applyFilters(
      source: state.allItems,
      filter: filter,
    );

    state = state.copyWith(
      filter: filter,
      filteredItems: filtered,
      viewState: filtered.isEmpty
          ? PembayaranViewState.empty
          : PembayaranViewState.success,
    );
  }

  void resetFilter() {
    final filtered = _applyFilters(
      source: state.allItems,
      filter: PembayaranFilterModel.empty,
    );

    state = state.copyWith(
      filter: PembayaranFilterModel.empty,
      filteredItems: filtered,
      viewState: filtered.isEmpty
          ? PembayaranViewState.empty
          : PembayaranViewState.success,
    );
  }

  void markAsPaid(String id) {
    final updated = state.allItems.map((item) {
      if (item.id == id) {
        return item.copyWith(status: PembayaranStatus.selesai);
      }
      return item;
    }).toList();

    final filtered = _applyFilters(
      source: updated,
      filter: state.filter,
    );

    state = state.copyWith(
      allItems: updated,
      filteredItems: filtered,
      viewState: filtered.isEmpty
          ? PembayaranViewState.empty
          : PembayaranViewState.success,
    );
  }

  PembayaranModel? findById(String id) {
    try {
      return state.allItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  List<PembayaranModel> _applyFilters({
    required List<PembayaranModel> source,
    required PembayaranFilterModel filter,
  }) {
    var result = List<PembayaranModel>.from(source);

    if (filter.startDate != null) {
      final start = DateTime(
        filter.startDate!.year,
        filter.startDate!.month,
        filter.startDate!.day,
      );

      result = result.where((item) {
        final itemDate = DateTime(
          item.tanggal.year,
          item.tanggal.month,
          item.tanggal.day,
        );
        return !itemDate.isBefore(start);
      }).toList();
    }

    if (filter.endDate != null) {
      final end = DateTime(
        filter.endDate!.year,
        filter.endDate!.month,
        filter.endDate!.day,
      );

      result = result.where((item) {
        final itemDate = DateTime(
          item.tanggal.year,
          item.tanggal.month,
          item.tanggal.day,
        );
        return !itemDate.isAfter(end);
      }).toList();
    }

    if (filter.status != null) {
      result = result.where((item) => item.status == filter.status).toList();
    }

    if (filter.sortType != null) {
      switch (filter.sortType!) {
        case PembayaranSortType.terbaru:
          result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
          break;
        case PembayaranSortType.terlama:
          result.sort((a, b) => a.tanggal.compareTo(b.tanggal));
          break;
        case PembayaranSortType.az:
          result.sort((a, b) => a.namaProjek.compareTo(b.namaProjek));
          break;
        case PembayaranSortType.za:
          result.sort((a, b) => b.namaProjek.compareTo(a.namaProjek));
          break;
      }
    }

    return result;
  }

  String formatCurrency(int value) {
    final raw = value.toString();
    final buffer = StringBuffer();
    int counter = 0;

    for (int i = raw.length - 1; i >= 0; i--) {
      buffer.write(raw[i]);
      counter++;
      if (counter == 3 && i != 0) {
        buffer.write('.');
        counter = 0;
      }
    }

    return 'Rp${buffer.toString().split('').reversed.join()}';
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }
}