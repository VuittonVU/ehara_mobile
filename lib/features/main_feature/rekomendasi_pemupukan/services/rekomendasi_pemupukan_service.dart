import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../onboarding/auth/services/auth_service.dart';

class RekomendasiPemupukanService {
  final AuthService authService;

  RekomendasiPemupukanService({
    required this.authService,
  });

  Future<Map<String, dynamic>> fetchDashboard({
    required String eHaraUuid,
  }) async {
    final token = await authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AuthService.baseUrl}/api/mobile/dashboard/get-dashboard-data'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['api-key'] = AuthService.apiKey;
    request.fields['e_hara_uuid'] = eHaraUuid;

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final decoded = _safeDecode(body);

    debugPrint('=== REKOM DASHBOARD STATUS: ${response.statusCode} ===');
    debugPrint('=== REKOM DASHBOARD BODY: $body ===');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil dashboard rekomendasi (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> fetchRecommendation({
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

    debugPrint('=== REKOM STATUS: ${response.statusCode} ===');
    debugPrint('=== REKOM BODY: $body ===');

    if (decoded['data'] is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data['fertilizer_recommendation'] is Map<String, dynamic>) {
        final fert =
        Map<String, dynamic>.from(data['fertilizer_recommendation']);

        debugPrint('=== FERTILIZER KEYS ===');
        debugPrint(fert.keys.toList().toString());

        fert.forEach((key, value) {
          debugPrint('KEY: $key => VALUE: $value');
        });
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil rekomendasi (${response.statusCode})',
    );
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    } catch (_) {
      return {'raw': body};
    }
  }

  String? _extractMessage(Map<String, dynamic> json) {
    if (json['message'] != null) {
      return json['message']?.toString();
    }

    if (json['meta'] is Map<String, dynamic>) {
      final meta = json['meta'] as Map<String, dynamic>;
      return meta['message']?.toString();
    }

    if (json['error'] != null) {
      return json['error']?.toString();
    }

    return null;
  }
}