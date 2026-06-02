import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/api_headers.dart';
import '../../../onboarding/auth/services/auth_service.dart';

class EHaraService {
  final AuthService authService;

  EHaraService({
    required this.authService,
  });

  static const String _s3BaseUrl =
      'https://iopri-storage-prod-ap-southeast-1-001.s3.ap-southeast-1.amazonaws.com/';

  final Map<String, Map<String, dynamic>> _dashboardCache = {};

  static String buildCsvUrl(String filename) {
    final cleanFilename = filename.replaceFirst(RegExp(r'^/+'), '');
    final encodedFilename = cleanFilename
        .split('/')
        .map(Uri.encodeComponent)
        .join('/');

    return '$_s3BaseUrl$encodedFilename';
  }

  Future<Map<String, dynamic>> getDashboardData({
    required String eHaraUuid,
    bool forceRefresh = false,
  }) async {
    if (_dashboardCache.containsKey(eHaraUuid) && !forceRefresh) {
      debugPrint('=== EHARA DASHBOARD FROM CACHE: $eHaraUuid ===');
      return _dashboardCache[eHaraUuid]!;
    }

    final token = await _requireToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AuthService.baseUrl}/api/mobile/dashboard/get-dashboard-data'),
    );

    request.headers.addAll(ApiHeaders.withToken(token));
    request.fields['e_hara_uuid'] = eHaraUuid;

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final decoded = _safeDecode(body);

    debugPrint('=== DASHBOARD STATUS: ${response.statusCode} ===');

    if (_isSuccess(response.statusCode)) {
      _dashboardCache[eHaraUuid] = decoded;
      return decoded;
    }

    throw Exception(
      _extractMessage(decoded) ??
          'Gagal mengambil dashboard (${response.statusCode})',
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
      return (json['meta'] as Map<String, dynamic>)['message']?.toString();
    }

    if (json['error'] != null) return json['error']?.toString();

    return null;
  }
}