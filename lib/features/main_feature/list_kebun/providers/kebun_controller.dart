import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/auth/services/auth_service.dart';
import '../data/kebun_repository.dart';
import '../models/kebun_filter_model.dart';
import '../models/kebun_model.dart';
import '../services/kebun_service.dart';

final kebunServiceProvider = Provider<KebunService>(
      (ref) => KebunService(
    authService: AuthService(),
  ),
);

final kebunRepositoryProvider = Provider<KebunRepository>(
      (ref) => KebunRepository(
    service: ref.read(kebunServiceProvider),
  ),
);

final kebunControllerProvider =
StateNotifierProvider<KebunController, AsyncValue<List<KebunModel>>>(
      (ref) => KebunController(
    repository: ref.read(kebunRepositoryProvider),
  )..loadKebun(),
);

class KebunController extends StateNotifier<AsyncValue<List<KebunModel>>> {
  final KebunRepository repository;

  KebunController({
    required this.repository,
  }) : super(const AsyncLoading());

  KebunFilterModel filter = KebunFilterModel.empty;
  List<KebunModel> original = [];

  Future<void> loadKebun() async {
    try {
      final rawList = await repository.getKebunList();

      final list = rawList
          .map((e) => KebunModel.fromApi(e))
          .where((e) => e.eHaraUuid.isNotEmpty)
          .toList();

      original = list;
      state = AsyncData(_applyFilterLogic());
    } catch (e, st) {
      debugPrint('=== KEBUN ERROR: $e ===');
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    await loadKebun();
  }

  void applyFilter(KebunFilterModel newFilter) {
    filter = newFilter;
    state = AsyncData(_applyFilterLogic());
  }

  List<KebunModel> _applyFilterLogic() {
    var result = [...original];

    if (filter.startAnalysisDate != null) {
      result = result.where((e) {
        final d = _onlyDate(e.tanggalAnalisis);
        final start = _onlyDate(filter.startAnalysisDate);
        return d != null &&
            start != null &&
            (d.isAfter(start) || d.isAtSameMomentAs(start));
      }).toList();
    }

    if (filter.endAnalysisDate != null) {
      result = result.where((e) {
        final d = _onlyDate(e.tanggalAnalisis);
        final end = _onlyDate(filter.endAnalysisDate);
        return d != null &&
            end != null &&
            (d.isBefore(end) || d.isAtSameMomentAs(end));
      }).toList();
    }

    if (filter.startPickupDate != null) {
      result = result.where((e) {
        final d = _onlyDate(e.tanggalPengambilanData);
        final start = _onlyDate(filter.startPickupDate);
        return d != null &&
            start != null &&
            (d.isAfter(start) || d.isAtSameMomentAs(start));
      }).toList();
    }

    if (filter.endPickupDate != null) {
      result = result.where((e) {
        final d = _onlyDate(e.tanggalPengambilanData);
        final end = _onlyDate(filter.endPickupDate);
        return d != null &&
            end != null &&
            (d.isBefore(end) || d.isAtSameMomentAs(end));
      }).toList();
    }

    switch (filter.sortType) {
      case KebunSortType.terbaru:
        result.sort(
              (a, b) => (b.tanggalAnalisis ?? DateTime(0)).compareTo(
            a.tanggalAnalisis ?? DateTime(0),
          ),
        );
        break;

      case KebunSortType.terlama:
        result.sort(
              (a, b) => (a.tanggalAnalisis ?? DateTime(0)).compareTo(
            b.tanggalAnalisis ?? DateTime(0),
          ),
        );
        break;

      case KebunSortType.az:
        result.sort(
              (a, b) => a.namaKebun.toLowerCase().compareTo(
            b.namaKebun.toLowerCase(),
          ),
        );
        break;

      case KebunSortType.za:
        result.sort(
              (a, b) => b.namaKebun.toLowerCase().compareTo(
            a.namaKebun.toLowerCase(),
          ),
        );
        break;

      case null:
        break;
    }

    return result;
  }

  DateTime? _onlyDate(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day);
  }
}