import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/auth/services/auth_service.dart';
import '../data/profile_api_repository.dart';
import '../models/profile_model.dart';
import 'profile_state.dart';

final profileRepositoryProvider = Provider<ProfileApiRepository>(
      (ref) => ProfileApiRepository(
    authService: AuthService(),
  ),
);

final profileControllerProvider =
StateNotifierProvider<ProfileController, ProfileState>(
      (ref) => ProfileController(
    repository: ref.read(profileRepositoryProvider),
  )..loadProfile(),
);

class ProfileController extends StateNotifier<ProfileState> {
  final ProfileApiRepository repository;

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

      print('=== LOAD PROFILE SUCCESS: ${profile.name}, ${profile.email} ===');

      state = state.copyWith(
        profile: profile,
        isLoading: false,
        viewState: ProfileViewState.success,
      );
    } catch (e) {
      print('=== LOAD PROFILE ERROR: $e ===');

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        viewState: ProfileViewState.error,
      );
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  void updateProfilePhoto(String photoPath) {
    if (state.profile == null) return;

    state = state.copyWith(
      profile: state.profile!.copyWith(
        photoPath: photoPath,
      ),
      viewState: ProfileViewState.success,
    );
  }

  void removeProfilePhoto() {
    if (state.profile == null) return;

    state = state.copyWith(
      profile: state.profile!.copyWith(
        photoPath: '',
      ),
      viewState: ProfileViewState.success,
    );
  }
}