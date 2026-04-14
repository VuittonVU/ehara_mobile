import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_placeholder_repository.dart';
import '../models/profile_model.dart';
import 'profile_state.dart';

final profileRepositoryProvider = Provider<ProfilePlaceholderRepository>(
      (ref) => ProfilePlaceholderRepository(),
);

final profileControllerProvider =
StateNotifierProvider<ProfileController, ProfileState>(
      (ref) => ProfileController(
    repository: ref.read(profileRepositoryProvider),
  )..loadProfile(),
);

class ProfileController extends StateNotifier<ProfileState> {
  final ProfilePlaceholderRepository repository;

  ProfileController({
    required this.repository,
  }) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
      viewState: ProfileViewState.loading,
    );

    try {
      final ProfileModel profile = await repository.getProfile();

      state = state.copyWith(
        profile: profile,
        isLoading: false,
        viewState: ProfileViewState.success,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat data profil',
        viewState: ProfileViewState.error,
      );
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}