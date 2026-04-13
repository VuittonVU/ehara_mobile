/* import 'dart:convert';

class AuthService {
  final ApiService _apiService = ApiService();
  final SecureStorageService _storage = SecureStorageService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      '/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      if (token != null) {
        await _storage.saveToken(token);
      }

      return {
        'success': true,
        'message': data['message'] ?? 'Login berhasil',
        'data': data,
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Login gagal',
    };
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null;
  }

  Future<bool> validateToken() async {
    final response = await _apiService.get('/profile', withAuth: true);
    return response.statusCode == 200;
  }

  Future<void> logout() async {
    await _storage.deleteToken();
  }
}
*/