import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/api_headers.dart';
import '../../../onboarding/auth/services/auth_service.dart';
import '../models/riwayat_model.dart';

class RiwayatService {
  final AuthService authService;

  RiwayatService({
    AuthService? authService,
  }) : authService = authService ?? AuthService();

  Future<List<RiwayatModel>> getRiwayatList() async {
    final token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

    final response = await http.get(
      Uri.parse(
        '${AuthService.baseUrl}/api/mobile/datatable?query_name=e_hara_2',
      ),
      headers: ApiHeaders.withToken(token),
    ).timeout(const Duration(seconds: 25));

    debugPrint('=== RIWAYAT STATUS: ${response.statusCode} ===');
    debugPrint('=== RIWAYAT BODY: ${response.body} ===');

    final decoded = _safeDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _extractMessage(decoded) ??
            'Gagal mengambil data riwayat (${response.statusCode})',
      );
    }

    final rows = _extractRows(decoded);

    final items = rows.map(RiwayatModel.fromMap).where((item) {
      return item.eHaraUuid.trim().isNotEmpty;
    }).toList();

    items.sort((a, b) => b.date.compareTo(a.date));

    return items;
  }

  List<Map<String, dynamic>> _extractRows(Map<String, dynamic> json) {
    final candidates = <dynamic>[
      json['data'],
      if (json['data'] is Map<String, dynamic>) (json['data'] as Map<String, dynamic>)['data'],
      if (json['data'] is Map<String, dynamic>) (json['data'] as Map<String, dynamic>)['rows'],
      json['rows'],
      json['result'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    return const [];
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