import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/auth/services/auth_service.dart';
import '../data/ehara_repository.dart';
import '../models/ehara_model.dart';
import '../services/ehara_service.dart';
import 'ehara_state.dart';

final eharaServiceProvider = Provider<EHaraService>(
      (ref) => EHaraService(
    authService: AuthService(),
  ),
);

final eharaRepositoryProvider = Provider<EHaraRepository>(
      (ref) => EHaraRepository(
    service: ref.read(eharaServiceProvider),
  ),
);

final eharaControllerProvider =
StateNotifierProvider<EHaraController, EHaraState>(
      (ref) => EHaraController(
    repository: ref.read(eharaRepositoryProvider),
  ),
);

class EHaraController extends StateNotifier<EHaraState> {
  final EHaraRepository repository;

  EHaraController({
    required this.repository,
  }) : super(EHaraState.initial());

  Future<void> loadDashboard({
    required String eHaraUuid,
  }) async {
    debugPrint('=== LOAD DASHBOARD UUID: $eHaraUuid ===');

    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    try {
      final raw = await repository.getDashboard(
        eHaraUuid: eHaraUuid,
      );

      debugPrint('=== DASHBOARD RAW: $raw ===');

      final dashboard = EHaraModel.fromApi(raw);

      debugPrint(
        '=== DASHBOARD MODEL: ${dashboard.estateName} | ${dashboard.analysisDate} ===',
      );
      debugPrint('=== N: ${dashboard.nValue} ===');
      debugPrint('=== P: ${dashboard.pValue} ===');
      debugPrint('=== K: ${dashboard.kValue} ===');
      debugPrint('=== MG: ${dashboard.mgValue} ===');
      debugPrint('=== HAS DATA: ${dashboard.hasData} ===');

      if (!dashboard.hasData) {
        throw Exception('Data E-HARA belum tersedia untuk kebun ini.');
      }

      state = state.copyWith(
        dashboard: dashboard,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('=== DASHBOARD ERROR: $e ===');

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}