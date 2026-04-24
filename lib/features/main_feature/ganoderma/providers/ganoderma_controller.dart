import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/auth/services/auth_service.dart';
import '../data/ganoderma_repository.dart';
import '../services/ganoderma_service.dart';
import 'ganoderma_state.dart';

final ganodermaServiceProvider = Provider<GanodermaService>(
      (ref) => GanodermaService(
    authService: AuthService(),
  ),
);

final ganodermaRepositoryProvider = Provider<GanodermaRepository>(
      (ref) => GanodermaRepository(
    service: ref.read(ganodermaServiceProvider),
  ),
);

final ganodermaControllerProvider =
StateNotifierProvider<GanodermaController, GanodermaState>(
      (ref) => GanodermaController(
    repository: ref.read(ganodermaRepositoryProvider),
  ),
);

class GanodermaController extends StateNotifier<GanodermaState> {
  final GanodermaRepository repository;

  GanodermaController({
    required this.repository,
  }) : super(GanodermaState.initial());

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

      debugPrint('=== GANODERMA KEBUN: ${result.namaKebun} ===');
      debugPrint('=== GANODERMA TOTAL POINTS: ${result.totalPoints} ===');
      debugPrint('=== GANODERMA DETECTED: ${result.detectedCount} ===');
      debugPrint('=== GANODERMA HEALTHY: ${result.healthyCount} ===');

      state = state.copyWith(
        data: result,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('=== GANODERMA ERROR: $e ===');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}