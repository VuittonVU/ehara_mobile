import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/auth/services/auth_service.dart';
import '../data/kebun_repository.dart';
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

  Future<void> loadKebun() async {
    try {
      final rawList = await repository.getKebunList();

      debugPrint('=== RAW KEBUN COUNT: ${rawList.length} ===');
      if (rawList.isNotEmpty) {
        debugPrint('=== RAW KEBUN FIRST: ${rawList.first} ===');
      }

      final list = rawList
          .map((e) => KebunModel.fromApi(e))
          .where((e) => e.eHaraUuid.isNotEmpty)
          .toList();

      debugPrint('=== MAPPED KEBUN COUNT: ${list.length} ===');
      if (list.isNotEmpty) {
        debugPrint(
          '=== MAPPED KEBUN FIRST: ${list.first.namaKebun} | ${list.first.eHaraUuid} ===',
        );
      }

      state = AsyncData(list);
    } catch (e, st) {
      debugPrint('=== KEBUN ERROR: $e ===');
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    await loadKebun();
  }
}