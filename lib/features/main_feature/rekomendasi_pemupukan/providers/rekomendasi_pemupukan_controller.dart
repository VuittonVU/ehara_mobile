import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/auth/services/auth_service.dart';
import '../data/rekomendasi_pemupukan_repository.dart';
import '../services/rekomendasi_pemupukan_service.dart';
import 'rekomendasi_pemupukan_state.dart';

final rekomendasiPemupukanServiceProvider =
Provider<RekomendasiPemupukanService>(
      (ref) => RekomendasiPemupukanService(
    authService: AuthService(),
  ),
);

final rekomendasiPemupukanRepositoryProvider =
Provider<RekomendasiPemupukanRepository>(
      (ref) => RekomendasiPemupukanRepository(
    service: ref.read(rekomendasiPemupukanServiceProvider),
  ),
);

final rekomendasiPemupukanControllerProvider = StateNotifierProvider<
    RekomendasiPemupukanController, RekomendasiPemupukanState>(
      (ref) => RekomendasiPemupukanController(
    repository: ref.read(rekomendasiPemupukanRepositoryProvider),
  ),
);

class RekomendasiPemupukanController
    extends StateNotifier<RekomendasiPemupukanState> {
  final RekomendasiPemupukanRepository repository;

  RekomendasiPemupukanController({
    required this.repository,
  }) : super(RekomendasiPemupukanState.initial());

  Future<void> load({
    required String eHaraUuid,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    try {
      final result = await repository.getData(
        eHaraUuid: eHaraUuid,
      );

      debugPrint('=== REKOM MODEL KEBUN: ${result.namaKebun} ===');
      debugPrint(
        '=== REKOM NPK: ${result.n}, ${result.p}, ${result.k}, ${result.mg} ===',
      );
      debugPrint('=== REKOM DOSIS COUNT: ${result.dosis.length} ===');

      for (final item in result.dosis) {
        debugPrint(
          '=== DOSE ITEM: ${item.title} | min=${item.minimum} | max=${item.maksimum} ===',
        );
      }

      state = state.copyWith(
        data: result,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('=== REKOM ERROR: $e ===');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}