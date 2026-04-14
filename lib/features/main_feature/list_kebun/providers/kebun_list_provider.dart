import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kebun_model.dart';

final kebunListProvider = Provider<List<KebunModel>>(
      (ref) => [
    KebunModel(
      id: 'kebun-1',
      namaKebun: 'Kwala Sawit',
      totalPohon: 286,
      tanggalAnalisis: DateTime(2026, 3, 9),
      tanggalPengambilanData: DateTime(2026, 3, 9),
    ),
    KebunModel(
      id: 'kebun-2',
      namaKebun: 'Kwala Sawit',
      totalPohon: 286,
      tanggalAnalisis: DateTime(2026, 3, 9),
      tanggalPengambilanData: DateTime(2026, 3, 9),
    ),
    KebunModel(
      id: 'kebun-3',
      namaKebun: 'Kwala Sawit',
      totalPohon: 286,
      tanggalAnalisis: DateTime(2026, 3, 9),
      tanggalPengambilanData: DateTime(2026, 3, 9),
    ),
  ],
);