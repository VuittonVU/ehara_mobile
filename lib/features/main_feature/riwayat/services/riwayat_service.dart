import '../models/riwayat_model.dart';

class RiwayatService {
  Future<List<RiwayatModel>> getRiwayatList() async {
    await Future.delayed(const Duration(milliseconds: 350));

    return [
      RiwayatModel(
        id: '1',
        projectName: 'Projek Nusantara',
        date: DateTime(2026, 3, 9),
        farmName: 'Kwala Sawit',
        isPublished: true,
      ),
      RiwayatModel(
        id: '2',
        projectName: 'Projek Nusantara',
        date: DateTime(2026, 3, 8),
        farmName: 'Kwala Sawit',
        isPublished: false,
      ),
      RiwayatModel(
        id: '3',
        projectName: 'Projek Nusantara',
        date: DateTime(2026, 3, 7),
        farmName: 'Kwala Sawit',
        isPublished: true,
      ),
    ];
  }
}