import '../services/ehara_service.dart';

class EHaraRepository {
  final EHaraService service;

  EHaraRepository({
    required this.service,
  });

  Future<Map<String, dynamic>> getDashboard({
    required String eHaraUuid,
    bool forceRefresh = false,
  }) {
    return service.getDashboardData(
      eHaraUuid: eHaraUuid,
      forceRefresh: forceRefresh,
    );
  }
}