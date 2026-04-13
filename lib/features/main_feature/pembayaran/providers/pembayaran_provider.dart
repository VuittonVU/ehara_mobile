import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pembayaran_filter_model.dart';
import '../models/pembayaran_model.dart';

class PembayaranProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final List<PembayaranModel> _allItems = [];

  List<PembayaranModel> _visibleItems = [];
  List<PembayaranModel> get visibleItems => _visibleItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  int _selectedLimit = 3;
  int get selectedLimit => _selectedLimit;

  PembayaranFilterModel _filter = PembayaranFilterModel.empty;
  PembayaranFilterModel get filter => _filter;

  String _searchQuery = '';
  Timer? _searchDebounce;

  bool _initialized = false;

  bool get hasActiveFilter => _filter.hasActiveFilter;

  Future<void> init() async {
    if (_initialized) return;

    _initialized = true;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 350));

      _allItems.addAll([
        PembayaranModel(
          id: '1',
          namaProjek: 'Projek Nusantara',
          tanggal: DateTime(2026, 3, 9),
          jumlahBaris: 286,
          status: PembayaranStatus.proses,
          kebun: 'Kwala Sawit',
          lokasi:
          'Jalan Kwala Sawit, Kwala Musam, Kecamatan Batang Serangan, Kabupaten Langkat, Sumatera Utara',
          hargaPerSatuanPohon: 108,
          totalPohon: 286,
          perkiraanLuasHa: 2.00,
          subTotal: 30800,
          orderId: '#e-Hara-605183',
        ),
        PembayaranModel(
          id: '2',
          namaProjek: 'Projek Nusantara',
          tanggal: DateTime(2026, 3, 9),
          jumlahBaris: 286,
          status: PembayaranStatus.selesai,
          kebun: 'Kwala Sawit',
          lokasi:
          'Jalan Kwala Sawit, Kwala Musam, Kecamatan Batang Serangan, Kabupaten Langkat, Sumatera Utara',
          hargaPerSatuanPohon: 108,
          totalPohon: 286,
          perkiraanLuasHa: 2.00,
          subTotal: 30800,
          orderId: '#e-Hara-605184',
        ),
        PembayaranModel(
          id: '3',
          namaProjek: 'Projek Nusantara',
          tanggal: DateTime(2026, 3, 9),
          jumlahBaris: 286,
          status: PembayaranStatus.dibatalkan,
          kebun: 'Kwala Sawit',
          lokasi:
          'Jalan Kwala Sawit, Kwala Musam, Kecamatan Batang Serangan, Kabupaten Langkat, Sumatera Utara',
          hargaPerSatuanPohon: 108,
          totalPohon: 286,
          perkiraanLuasHa: 2.00,
          subTotal: 30800,
          orderId: '#e-Hara-605185',
        ),
      ]);

      _applyAll();
    } catch (e) {
      _errorMessage = 'Gagal memuat data pembayaran.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      _searchQuery = value.trim().toLowerCase();
      _applyAll();
    });
  }

  void onLimitChanged(int value) {
    _selectedLimit = value;
    _applyAll();
  }

  void applyFilter(PembayaranFilterModel value) {
    _filter = value;
    _applyAll();
  }

  void resetFilter() {
    _filter = PembayaranFilterModel.empty;
    _applyAll();
  }

  void markAsPaid(String id) {
    final index = _allItems.indexWhere((e) => e.id == id);
    if (index == -1) return;

    _allItems[index] = _allItems[index].copyWith(
      status: PembayaranStatus.selesai,
    );
    _applyAll();
  }

  void _applyAll() {
    List<PembayaranModel> result = List.from(_allItems);

    if (_searchQuery.isNotEmpty) {
      result = result.where((item) {
        return item.namaProjek.toLowerCase().contains(_searchQuery) ||
            item.kebun.toLowerCase().contains(_searchQuery) ||
            item.lokasi.toLowerCase().contains(_searchQuery) ||
            item.orderId.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    if (_filter.startDate != null) {
      result = result.where((item) {
        final itemDate = DateTime(
          item.tanggal.year,
          item.tanggal.month,
          item.tanggal.day,
        );
        final start = DateTime(
          _filter.startDate!.year,
          _filter.startDate!.month,
          _filter.startDate!.day,
        );
        return !itemDate.isBefore(start);
      }).toList();
    }

    if (_filter.endDate != null) {
      result = result.where((item) {
        final itemDate = DateTime(
          item.tanggal.year,
          item.tanggal.month,
          item.tanggal.day,
        );
        final end = DateTime(
          _filter.endDate!.year,
          _filter.endDate!.month,
          _filter.endDate!.day,
        );
        return !itemDate.isAfter(end);
      }).toList();
    }

    if (_filter.status != null) {
      result = result.where((item) => item.status == _filter.status).toList();
    }

    switch (_filter.sortType) {
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

    if (result.length > _selectedLimit) {
      result = result.take(_selectedLimit).toList();
    }

    _visibleItems = result;
    notifyListeners();
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

  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}