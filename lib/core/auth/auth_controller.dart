import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/auth/services/auth_service.dart';
import 'auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(ref.read(authServiceProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(AuthState.initial()) {
    loadSession();
  }

  Future<void> loadSession() async {
    final token = await _authService.getToken();

    if (token != null && token.isNotEmpty) {
      state = state.copyWith(
        isLoggedIn: true,
        token: token,
        clearError: true,
      );
    }
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final result = await _authService.login(
        identifier: identifier,
        password: password,
      );

      final token = result['token']?.toString();

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        token: token,
        clearError: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        clearToken: true,
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (_) {}

    state = AuthState.initial();
  }
}