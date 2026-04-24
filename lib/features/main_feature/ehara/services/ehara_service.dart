import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../onboarding/auth/services/auth_service.dart';

class EHaraService {
  final AuthService authService;

  EHaraService({
    required this.authService,
  });

  Future<Map<String, dynamic>> getDashboardData({
    required String eHaraUuid,
  }) async {
    final token = await authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

    debugPrint('=== DASHBOARD TOKEN: $token ===');
    debugPrint('=== DASHBOARD UUID SENT: $eHaraUuid ===');

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

    debugPrint('=== DASHBOARD STATUS: ${response.statusCode} ===');
    debugPrint('=== DASHBOARD BODY: $body ===');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil dashboard (${response.statusCode})',
    );
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