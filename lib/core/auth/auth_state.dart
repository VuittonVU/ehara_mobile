class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? token;
  final String? errorMessage;

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    required this.token,
    required this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoggedIn: false,
      isLoading: false,
      token: null,
      errorMessage: null,
    );
  }

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? token,
    String? errorMessage,
    bool clearToken = false,
    bool clearError = false,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      token: clearToken ? null : (token ?? this.token),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}