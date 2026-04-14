import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kebun_feature_type.dart';
import '../models/kebun_model.dart';
import 'kebun_selection_state.dart';

final kebunSelectionControllerProvider =
    StateNotifierProvider<KebunSelectionController, KebunSelectionState>(
  (ref) => KebunSelectionController(),
);

class KebunSelectionController extends StateNotifier<KebunSelectionState> {
  KebunSelectionController() : super(KebunSelectionState.initial());

  void setSelectedFeature(KebunFeatureType feature) {
    state = state.copyWith(
      selectedFeature: feature,
      clearSelectedKebun: true,
    );
  }

  void setSelectedKebun(KebunModel kebun) {
    state = state.copyWith(
      selectedKebun: kebun,
    );
  }

  void clearSelection() {
    state = KebunSelectionState.initial();
  }
}