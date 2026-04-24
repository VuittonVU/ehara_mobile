import '../models/ganoderma_model.dart';
import '../services/ganoderma_service.dart';

class GanodermaRepository {
  final GanodermaService service;

  GanodermaRepository({
    required this.service,
  });

  Future<GanodermaModel> getData({
    required String eHaraUuid,
  }) async {
    final ganodermaRows = await service.fetchGanoderma(
      eHaraUuid: eHaraUuid,
    );

    final recommendationMeta = await service.fetchRecommendationMeta(
      eHaraUuid: eHaraUuid,
    );

    return GanodermaModel.fromApi(
      ganodermaRows: ganodermaRows,
      recommendationJson: recommendationMeta,
    );
  }
}