class AuthState {
  final bool isLoggedIn;

  const AuthState({
    required this.isLoggedIn,
  });

  factory AuthState.initial() {
    return const AuthState(isLoggedIn: false);
  }

  AuthState copyWith({
    bool? isLoggedIn,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}