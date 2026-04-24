import '../services/kebun_service.dart';

class KebunRepository {
  final KebunService service;

  KebunRepository({
    required this.service,
  });

  Future<List<Map<String, dynamic>>> getKebunList() {
    return service.fetchKebunList();
  }
}