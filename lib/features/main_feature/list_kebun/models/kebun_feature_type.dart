enum KebunFeatureType {
  ehara,
  rekomendasiPemupukan,
  ganoderma,
}

extension KebunFeatureTypeX on KebunFeatureType {
  String get label {
    switch (this) {
      case KebunFeatureType.ehara:
        return 'e-Hara';
      case KebunFeatureType.rekomendasiPemupukan:
        return 'Rekomendasi Pemupukan';
      case KebunFeatureType.ganoderma:
        return 'Ganoderma';
    }
  }
}