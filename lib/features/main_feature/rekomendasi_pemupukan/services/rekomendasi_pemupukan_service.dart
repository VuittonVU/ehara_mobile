import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/api_headers.dart';
import '../../../onboarding/auth/services/auth_service.dart';

class RekomendasiPemupukanService {
  final AuthService authService;

  RekomendasiPemupukanService({
    required this.authService,
  });

  final Map<String, Map<String, dynamic>> _dashboardCache = {};
  final Map<String, Map<String, dynamic>> _recommendationCache = {};

  Future<Map<String, dynamic>> fetchDashboard({
    required String eHaraUuid,
    bool forceRefresh = false,
  }) async {
    if (_dashboardCache.containsKey(eHaraUuid) && !forceRefresh) {
      debugPrint('=== REKOM DASHBOARD FROM CACHE: $eHaraUuid ===');
      return _dashboardCache[eHaraUuid]!;
    }

    final token = await _requireToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AuthService.baseUrl}/api/mobile/dashboard/get-dashboard-data'),
    );

    request.headers.addAll(ApiHeaders.withToken(token));
    request.fields['e_hara_uuid'] = eHaraUuid;

    final response = await request.send().timeout(const Duration(seconds: 25));
    final body = await response.stream.bytesToString();
    final decoded = _safeDecode(body);

    debugPrint('=== REKOM DASHBOARD STATUS: ${response.statusCode} ===');
    debugPrint('=== REKOM DASHBOARD BODY: $body ===');

    if (_isSuccess(response.statusCode)) {
      _dashboardCache[eHaraUuid] = decoded;
      return decoded;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil dashboard rekomendasi (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> fetchRecommendation({
    required String eHaraUuid,
    bool forceRefresh = false,
  }) async {
    if (_recommendationCache.containsKey(eHaraUuid) && !forceRefresh) {
      debugPrint('=== REKOM FROM CACHE: $eHaraUuid ===');
      return _recommendationCache[eHaraUuid]!;
    }

    final token = await _requireToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${AuthService.baseUrl}/api/mobile/dashboard/fertilizer-recommendation/get-data',
      ),
    );

    request.headers.addAll(ApiHeaders.withToken(token));
    request.fields['e_hara_uuid'] = eHaraUuid;

    final response = await request.send().timeout(const Duration(seconds: 25));
    final body = await response.stream.bytesToString();
    final decoded = _safeDecode(body);

    debugPrint('=== REKOM STATUS: ${response.statusCode} ===');
    debugPrint('=== REKOM BODY: $body ===');

    if (_isSuccess(response.statusCode)) {
      _recommendationCache[eHaraUuid] = decoded;
      return decoded;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil rekomendasi (${response.statusCode})',
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
      final meta = json['meta'] as Map<String, dynamic>;
      return meta['message']?.toString();
    }

    if (json['error'] != null) return json['error']?.toString();

    return null;
  }
}