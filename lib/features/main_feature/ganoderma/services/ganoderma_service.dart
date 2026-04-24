import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../onboarding/auth/services/auth_service.dart';

class GanodermaService {
  final AuthService authService;

  GanodermaService({
    required this.authService,
  });

  Future<List<dynamic>> fetchGanoderma({
    required String eHaraUuid,
  }) async {
    final token = await authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${AuthService.baseUrl}/api/mobile/dashboard/ganoderma/get-data',
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['api-key'] = AuthService.apiKey;
    request.fields['e_hara_uuid'] = eHaraUuid;

    final response = await request.send();
    final body = await response.stream.bytesToString();

    debugPrint('=== GANODERMA STATUS: ${response.statusCode} ===');
    debugPrint('=== GANODERMA BODY: $body ===');

    final decoded = _safeDecode(body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded['data'] is List) {
        return decoded['data'] as List<dynamic>;
      }
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
    final token = await authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

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
    final decoded = _safeDecode(body);

    debugPrint('=== GANODERMA META STATUS: ${response.statusCode} ===');
    debugPrint('=== GANODERMA META BODY: $body ===');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    return <String, dynamic>{};
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