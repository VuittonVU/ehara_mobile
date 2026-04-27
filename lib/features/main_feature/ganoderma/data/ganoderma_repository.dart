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
    final results = await Future.wait<dynamic>([
      service.fetchGanoderma(eHaraUuid: eHaraUuid),
      service.fetchRecommendationMeta(eHaraUuid: eHaraUuid),
      service.fetchEHaraDatatable(),
    ]);

    final ganodermaRows = results[0] as List<dynamic>;
    final recommendationMeta = results[1] as Map<String, dynamic>;
    final eHaraRows = results[2] as List<dynamic>;

    final csvUrl = GanodermaModel.extractGanodermaCsvUrlFromDatatable(
      rows: eHaraRows,
      eHaraUuid: eHaraUuid,
    );

    return GanodermaModel.fromApi(
      ganodermaRows: ganodermaRows,
      recommendationJson: recommendationMeta,
      csvUrl: csvUrl,
    );
  }
}