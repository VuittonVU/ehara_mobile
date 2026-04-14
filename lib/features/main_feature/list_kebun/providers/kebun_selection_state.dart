import '../models/kebun_feature_type.dart';
import '../models/kebun_model.dart';

class KebunSelectionState {
  final KebunFeatureType? selectedFeature;
  final KebunModel? selectedKebun;

  const KebunSelectionState({
    this.selectedFeature,
    this.selectedKebun,
  });

  factory KebunSelectionState.initial() {
    return const KebunSelectionState(
      selectedFeature: null,
      selectedKebun: null,
    );
  }

  KebunSelectionState copyWith({
    KebunFeatureType? selectedFeature,
    bool clearSelectedFeature = false,
    KebunModel? selectedKebun,
    bool clearSelectedKebun = false,
  }) {
    return KebunSelectionState(
      selectedFeature: clearSelectedFeature
          ? null
          : (selectedFeature ?? this.selectedFeature),
      selectedKebun:
      clearSelectedKebun ? null : (selectedKebun ?? this.selectedKebun),
    );
  }
}