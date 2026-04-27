import '../models/rekomendasi_pemupukan_model.dart';
import '../services/rekomendasi_pemupukan_service.dart';

class RekomendasiPemupukanRepository {
  final RekomendasiPemupukanService service;

  RekomendasiPemupukanRepository({
    required this.service,
  });

  Future<RekomendasiPemupukanModel> getData({
    required String eHaraUuid,
    bool forceRefresh = false,
  }) async {
    final results = await Future.wait<Map<String, dynamic>>([
      service.fetchDashboard(
        eHaraUuid: eHaraUuid,
        forceRefresh: forceRefresh,
      ),
      service.fetchRecommendation(
        eHaraUuid: eHaraUuid,
        forceRefresh: forceRefresh,
      ),
    ]);

    final dashboard = results[0];
    final recommendation = results[1];

    return RekomendasiPemupukanModel.fromApi(
      dashboardJson: dashboard,
      recommendationJson: recommendation,
    );
  }
}