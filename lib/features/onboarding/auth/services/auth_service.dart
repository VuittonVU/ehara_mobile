import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/app_user_model.dart';

class AuthService {
  AuthService();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'ehara_auth_token';
  static const String _userKey = 'ehara_user';
  static const String _apiKey = 'ppks2020';

  static const String baseUrl = 'https://ehara.iopri.co.id';

  static String get apiKey => _apiKey;

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/auth/sign-in'),
    );

    request.headers['api-key'] = _apiKey;
    request.fields['email'] = identifier.trim();
    request.fields['password'] = password;

    final streamedResponse = await request.send();
    final body = await streamedResponse.stream.bytesToString();
    final decoded = _safeDecode(body);

    if (streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300) {
      final token = _extractToken(decoded);

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan pada response login.');
      }

      await saveToken(token);

      final userMap = _extractUserMap(decoded);
      if (userMap != null) {
        await saveUser(userMap);
      }

      return {
        'success': true,
        'message': _extractMessage(decoded) ?? 'Login berhasil',
        'token': token,
        'user': userMap != null ? AppUserModel.fromMap(userMap) : null,
        'raw': decoded,
      };
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Login gagal (${streamedResponse.statusCode})',
    );
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String address,
    required String email,
    required String phone,
    required String whatsapp,
    required String password,
  }) async {
    throw Exception(
      'Endpoint pendaftaran belum tersedia dari backend PPKS.',
    );
  }

  Future<AppUserModel?> getProfile() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/mobile/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final decoded = _safeDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> profileMap = decoded;

      if (decoded['data'] is Map<String, dynamic>) {
        final outerData = Map<String, dynamic>.from(decoded['data']);

        if (outerData['data'] is Map<String, dynamic>) {
          profileMap = Map<String, dynamic>.from(outerData['data']);
        } else {
          profileMap = outerData;
        }
      }

      final user = AppUserModel.fromMap(profileMap);
      await saveUser(profileMap);
      return user;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil profile (${response.statusCode})',
    );
  }

  Future<List<dynamic>> getAnalisisData({
    String queryName = 'e_hara_2',
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/mobile/datatable?query_name=$queryName'),
      headers: {
        'Authorization': 'Bearer $token',
        'api-key': _apiKey,
        'Accept': 'application/json',
      },
    );

    final decoded = _safeDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final rawData = decoded['data'];

      if (rawData is List) return rawData;
      if (rawData is Map<String, dynamic>) return [rawData];

      return [];
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil data analisis (${response.statusCode})',
    );
  }

  Future<List<dynamic>> getCertificateList() async {
    return getAnalisisData(queryName: 'e_hara_certificate');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user));
  }

  Future<AppUserModel?> getSavedUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AppUserModel.fromMap(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, String>> authorizedHeaders({
    bool withApiKey = false,
  }) async {
    final token = await getToken();

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (withApiKey) {
      headers['api-key'] = _apiKey;
    }

    return headers;
  }

  String? _extractToken(Map<String, dynamic> json) {
    final candidates = [
      json['token'],
      json['access_token'],
      json['accessToken'],
      (json['data'] is Map ? json['data']['token'] : null),
      (json['data'] is Map ? json['data']['access_token'] : null),
      (json['data'] is Map ? json['data']['accessToken'] : null),
    ];

    for (final item in candidates) {
      if (item is String && item.isNotEmpty) return item;
    }
    return null;
  }

  Map<String, dynamic>? _extractUserMap(Map<String, dynamic> json) {
    if (json['user'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(json['user']);
    }

    if (json['data'] is Map<String, dynamic>) {
      final data = Map<String, dynamic>.from(json['data']);
      if (data['user'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data['user']);
      }
      return data;
    }

    return null;
  }

  String? _extractMessage(Map<String, dynamic> json) {
    if (json['message'] != null) return json['message']?.toString();

    if (json['meta'] is Map<String, dynamic>) {
      return json['meta']['message']?.toString();
    }

    return null;
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } catch (_) {
      return {'raw': body};
    }
  }
}