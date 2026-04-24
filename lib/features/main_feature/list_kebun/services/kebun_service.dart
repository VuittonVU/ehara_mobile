import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../onboarding/auth/services/auth_service.dart';

class KebunService {
  final AuthService authService;

  KebunService({
    required this.authService,
  });

  Future<List<Map<String, dynamic>>> fetchKebunList() async {
    final token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

    final response = await http.get(
      Uri.parse(
        '${AuthService.baseUrl}/api/mobile/datatable?query_name=e_hara_2',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'api-key': AuthService.apiKey,
        'Accept': 'application/json',
      },
    );

    debugPrint('=== KEBUN STATUS: ${response.statusCode} ===');
    debugPrint('=== KEBUN BODY: ${response.body} ===');

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      dynamic current = decoded;

      while (current is Map<String, dynamic>) {
        if (current['data'] is List) {
          return List<Map<String, dynamic>>.from(current['data']);
        }
        if (current['rows'] is List) {
          return List<Map<String, dynamic>>.from(current['rows']);
        }
        if (current['result'] is List) {
          return List<Map<String, dynamic>>.from(current['result']);
        }
        if (current['data'] is Map<String, dynamic>) {
          current = current['data'];
          continue;
        }
        break;
      }

      return [];
    }

    throw Exception('Gagal mengambil list kebun (${response.statusCode})');
  }
}