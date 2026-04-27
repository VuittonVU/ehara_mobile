import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../onboarding/auth/services/auth_service.dart';

class GanodermaService {
  final AuthService authService;

  GanodermaService({
    required this.authService,
  });

  List<dynamic>? _cachedEHaraRows;

  Future<List<dynamic>> fetchGanoderma({
    required String eHaraUuid,
  }) async {
    final token = await _requireToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AuthService.baseUrl}/api/mobile/dashboard/ganoderma/get-data'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['api-key'] = AuthService.apiKey;
    request.fields['e_hara_uuid'] = eHaraUuid;

    final response = await request.send();
    final body = await response.stream.bytesToString();

    debugPrint('=== GANODERMA STATUS: ${response.statusCode} ===');
    debugPrint('=== GANODERMA BODY: $body ===');

    final decoded = _safeDecode(body);

    if (_isSuccess(response.statusCode)) {
      final data = decoded['data'];
      if (data is List) return data;
      return [];
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil data ganoderma (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> fetchRecommendationMeta({
    required String eHaraUuid,
  }) async {
    final token = await _requireToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${AuthService.baseUrl}/api/mobile/dashboard/fertilizer-recommendation/get-data',
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['api-key'] = AuthService.apiKey;
    request.fields['e_hara_uuid'] = eHaraUuid;

    final response = await request.send();
    final body = await response.stream.bytesToString();

    debugPrint('=== GANODERMA META STATUS: ${response.statusCode} ===');
    debugPrint('=== GANODERMA META BODY: $body ===');

    final decoded = _safeDecode(body);

    if (_isSuccess(response.statusCode)) {
      return decoded;
    }

    return <String, dynamic>{};
  }

  Future<List<dynamic>> fetchEHaraDatatable({
    bool forceRefresh = false,
  }) async {
    if (_cachedEHaraRows != null && !forceRefresh) {
      debugPrint(
        '=== EHARA DATATABLE FROM CACHE: ${_cachedEHaraRows!.length} rows ===',
      );
      return _cachedEHaraRows!;
    }

    final token = await _requireToken();

    final uri = Uri.parse(
      '${AuthService.baseUrl}/api/mobile/datatable?query_name=e_hara_2',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'api-key': AuthService.apiKey,
        'Accept': 'application/json',
      },
    );

    debugPrint('=== EHARA DATATABLE STATUS: ${response.statusCode} ===');

    final decoded = _safeDecode(response.body);

    if (_isSuccess(response.statusCode)) {
      final result = _extractList(decoded);
      _cachedEHaraRows = result;

      debugPrint('=== EHARA DATATABLE CACHED: ${result.length} rows ===');
      return result;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil datatable e_hara_2 (${response.statusCode})',
    );
  }

  Future<String> _requireToken() async {
    final token = await authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }
    return token;
  }

  bool _isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  List<dynamic> _extractList(Map<String, dynamic> decoded) {
    final data = decoded['data'];

    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      if (data['data'] is List) return data['data'] as List<dynamic>;
      if (data['rows'] is List) return data['rows'] as List<dynamic>;
      if (data['items'] is List) return data['items'] as List<dynamic>;
      if (data['records'] is List) return data['records'] as List<dynamic>;
    }

    return [];
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

  String? _extractMessage(Map<String, dynamic> json) {
    if (json['message'] != null) return json['message']?.toString();

    if (json['meta'] is Map<String, dynamic>) {
      return (json['meta'] as Map<String, dynamic>)['message']?.toString();
    }

    if (json['error'] != null) return json['error']?.toString();

    return null;
  }
}