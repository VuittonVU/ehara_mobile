import 'package:flutter/material.dart';
import '../../data/riwayat_repository.dart';
import '../../models/riwayat_filter_model.dart';
import '../../models/riwayat_item_model.dart';

class RiwayatController extends ChangeNotifier {
  final RiwayatRepository repository;

  RiwayatController({required this.repository});

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  List<RiwayatItemModel> _allItems = [];
  List<RiwayatItemModel> visibleItems = [];

  int selectedLimit = 3;
  RiwayatFilterModel filter = RiwayatFilterModel.initial;

  Future<void> loadRiwayat() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      _allItems = await repository.getRiwayatAnalisis();
      _applyFilters();
    } catch (e) {
      errorMessage = 'Gagal memuat data riwayat.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String value) {
    _applyFilters();
    notifyListeners();
  }

  void onLimitChanged(int value) {
    selectedLimit = value;
    _applyFilters();
    notifyListeners();
  }

  void applyFilter(RiwayatFilterModel newFilter) {
    filter = newFilter;
    _applyFilters();
    notifyListeners();
  }

  void resetFilter() {
    filter = RiwayatFilterModel.initial;
    _applyFilters();
    notifyListeners();
  }

  bool get hasActiveFilter => filter.hasActiveFilter;

  void _applyFilters() {
    final keyword = searchController.text.trim().toLowerCase();

    List<RiwayatItemModel> filtered = _allItems.where((item) {
      final matchesKeyword = keyword.isEmpty ||
          item.namaProyek.toLowerCase().contains(keyword) ||
          item.namaPerusahaan.toLowerCase().contains(keyword) ||
          item.namaCustomer.toLowerCase().contains(keyword) ||
          item.namaKebun.toLowerCase().contains(keyword) ||
          item.alamatLengkap.toLowerCase().contains(keyword) ||
          item.kodeAnalisis.toLowerCase().contains(keyword) ||
          (item.nomorSertifikat?.toLowerCase().contains(keyword) ?? false);

      if (!matchesKeyword) return false;

      final itemDate = DateTime(
        item.tanggalAnalisis.year,
        item.tanggalAnalisis.month,
        item.tanggalAnalisis.day,
      );

      if (filter.startDate != null) {
        final start = DateTime(
          filter.startDate!.year,
          filter.startDate!.month,
          filter.startDate!.day,
        );
        if (itemDate.isBefore(start)) return false;
      }

      if (filter.endDate != null) {
        final end = DateTime(
          filter.endDate!.year,
          filter.endDate!.month,
          filter.endDate!.day,
        );
        if (itemDate.isAfter(end)) return false;
      }

      switch (filter.certificateFilter) {
        case RiwayatCertificateFilter.semua:
          break;
        case RiwayatCertificateFilter.sudahTerbit:
          if (!item.isSertifikatTerbit) return false;
          break;
        case RiwayatCertificateFilter.belumTerbit:
          if (item.isSertifikatTerbit) return false;
          break;
      }

      return true;
    }).toList();

    switch (filter.sortOption) {
      case RiwayatSortOption.terbaru:
        filtered.sort(
              (a, b) => b.tanggalAnalisis.compareTo(a.tanggalAnalisis),
        );
        break;
      case RiwayatSortOption.terlama:
        filtered.sort(
              (a, b) => a.tanggalAnalisis.compareTo(b.tanggalAnalisis),
        );
        break;
      case RiwayatSortOption.az:
        filtered.sort(
              (a, b) => a.namaProyek.toLowerCase().compareTo(
            b.namaProyek.toLowerCase(),
          ),
        );
        break;
      case RiwayatSortOption.za:
        filtered.sort(
              (a, b) => b.namaProyek.toLowerCase().compareTo(
            a.namaProyek.toLowerCase(),
          ),
        );
        break;
    }

    if (selectedLimit >= filtered.length) {
      visibleItems = filtered;
    } else {
      visibleItems = filtered.take(selectedLimit).toList();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}