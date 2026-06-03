import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/api_headers.dart';
import '../models/app_user_model.dart';

class AuthService {
  AuthService();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'ehara_auth_token';
  static const String _userKey = 'ehara_user';
  static const String _apiKey = ApiHeaders.apiKey;

  static const String baseUrl = 'https://ehara.iopri.co.id';
  static const Duration _requestTimeout = Duration(seconds: 25);

  static String get apiKey => _apiKey;

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/auth/sign-in'),
    );

    request.headers.addAll(ApiHeaders.noAuth());
    request.fields['email'] = identifier.trim();
    request.fields['password'] = password;

    final streamedResponse = await request.send().timeout(_requestTimeout);
    final body = await streamedResponse.stream.bytesToString();

    final decoded = _safeDecode(body);

    if (streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300) {
      final token = _extractToken(decoded);

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan pada response login.');
      }

      await _storage.delete(key: _userKey);
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

  Future<Map<String, dynamic>> loginWithGoogleIdToken({
    required String idToken,
  }) {
    return loginWithFirebaseIdToken(idToken: idToken);
  }

  Future<Map<String, dynamic>> loginWithFirebaseIdToken({
    required String idToken,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/auth/firebase/mobile-callback'),
    );

    request.headers.addAll(ApiHeaders.noAuth());
    request.fields['id_token'] = idToken;

    final streamedResponse = await request.send().timeout(_requestTimeout);
    final body = await streamedResponse.stream.bytesToString();

    debugPrint('FIREBASE CALLBACK STATUS: ${streamedResponse.statusCode}');
    debugPrint('FIREBASE CALLBACK BODY: $body');

    final decoded = _safeDecode(body);

    if (streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300) {
      final token = _extractToken(decoded);

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan pada response Firebase login.');
      }

      await _storage.delete(key: _userKey);
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
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/auth/sign-up'),
    );

    request.headers.addAll(ApiHeaders.noAuth());

    request.fields['name'] = fullName.trim();
    request.fields['email'] = email.trim();
    request.fields['username'] = username.trim();
    request.fields['password'] = password;
    request.fields['confirm_password'] = password;
    request.fields['role'] = 'user';

    final cleanAddress = address.trim();
    final cleanPhone = phone.trim();
    final cleanWhatsapp = whatsapp.trim();

    if (cleanAddress.isNotEmpty) {
      request.fields['address'] = cleanAddress;
    }
    if (cleanPhone.isNotEmpty) {
      request.fields['handphone_no'] = cleanPhone;
    }
    if (cleanWhatsapp.isNotEmpty) {
      request.fields['whatsapp_no'] = cleanWhatsapp;
    }

    final streamedResponse = await request.send().timeout(_requestTimeout);
    final body = await streamedResponse.stream.bytesToString();

    final decoded = _safeDecode(body);

    if (streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300) {
      return {
        'success': true,
        'message': _extractMessage(decoded) ??
            'Pendaftaran berhasil. Verifikasi email sementara masih dalam perbaikan.',
        'raw': decoded,
      };
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Pendaftaran gagal (${streamedResponse.statusCode})',
    );
  }

  Future<AppUserModel?> getProfile() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/mobile/profile'),
      headers: ApiHeaders.withToken(token),
    ).timeout(_requestTimeout);

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
      headers: ApiHeaders.withToken(token),
    ).timeout(_requestTimeout);

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

  Future<List<dynamic>> getCertificateList() {
    return getAnalisisData(queryName: 'e_hara_certificate');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (_) {}
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

    if (token != null && token.isNotEmpty) {
      return ApiHeaders.withToken(token);
    }

    return ApiHeaders.noAuth();
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
    if (json['error'] is Map<String, dynamic>) {
      final errors = Map<String, dynamic>.from(json['error']);
      final messages = <String>[];

      errors.forEach((key, value) {
        if (value is List) {
          messages.addAll(
            value.map((e) => _translateBackendMessage(e.toString())),
          );
        } else if (value != null) {
          messages.add(_translateBackendMessage(value.toString()));
        }
      });

      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    if (json['message'] != null) {
      return _translateBackendMessage(json['message'].toString());
    }

    if (json['meta'] is Map<String, dynamic>) {
      final message = json['meta']['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return _translateBackendMessage(message);
      }
    }

    if (json['errors'] != null) {
      return _translateBackendMessage(json['errors'].toString());
    }

    return null;
  }

  String _translateBackendMessage(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('whatsapp no has already been taken')) {
      return 'Nomor WhatsApp sudah digunakan.';
    }

    if (lower.contains('email sudah pernah digunakan')) {
      return 'Email sudah pernah digunakan.';
    }

    if (lower.contains('email has already been taken') ||
        lower.contains('email already exists')) {
      return 'Email sudah digunakan.';
    }

    if (lower.contains('username has already been taken') ||
        lower.contains('username already exists')) {
      return 'Username sudah digunakan.';
    }

    if (lower.contains('bad request')) {
      return 'Data pendaftaran belum sesuai.';
    }

    return message;
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