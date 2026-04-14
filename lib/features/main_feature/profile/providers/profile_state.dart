import '../models/profile_model.dart';

enum ProfileViewState {
  initial,
  loading,
  success,
  error,
}

class ProfileState {
  final ProfileModel? profile;
  final bool isLoading;
  final String? errorMessage;
  final ProfileViewState viewState;

  const ProfileState({
    required this.profile,
    required this.isLoading,
    required this.errorMessage,
    required this.viewState,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      profile: null,
      isLoading: false,
      errorMessage: null,
      viewState: ProfileViewState.initial,
    );
  }

  ProfileState copyWith({
    ProfileModel? profile,
    bool clearProfile = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    ProfileViewState? viewState,
  }) {
    return ProfileState(
      profile: clearProfile ? null : (profile ?? this.profile),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      viewState: viewState ?? this.viewState,
    );
  }
}