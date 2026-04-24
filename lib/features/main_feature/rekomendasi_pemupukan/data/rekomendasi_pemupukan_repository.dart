import '../models/rekomendasi_pemupukan_model.dart';
import '../services/rekomendasi_pemupukan_service.dart';

class RekomendasiPemupukanRepository {
  final RekomendasiPemupukanService service;

  RekomendasiPemupukanRepository({
    required this.service,
  });

  Future<RekomendasiPemupukanModel> getData({
    required String eHaraUuid,
  }) async {
    final dashboard = await service.fetchDashboard(eHaraUuid: eHaraUuid);
    final recommendation = await service.fetchRecommendation(eHaraUuid: eHaraUuid);

    return RekomendasiPemupukanModel.fromApi(
      dashboardJson: dashboard,
      recommendationJson: recommendation,
    );
  }
}