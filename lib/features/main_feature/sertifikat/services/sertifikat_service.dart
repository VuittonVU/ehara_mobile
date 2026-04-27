import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../../onboarding/auth/services/auth_service.dart';
import '../models/sertifikat_model.dart';

class SertifikatService {
  final AuthService authService;

  SertifikatService({AuthService? authService})
      : authService = authService ?? AuthService();

  static const String _s3BaseUrl =
      'https://iopri-storage-prod-ap-southeast-1-001.s3.ap-southeast-1.amazonaws.com/';

  Future<List<SertifikatModel>> getCertificates() async {
    final token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan.');
    }

    final response = await http.get(
      Uri.parse(
        '${AuthService.baseUrl}/api/mobile/datatable?query_name=e_hara_certificate',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'api-key': AuthService.apiKey,
        'Accept': 'application/json',
      },
    );

    debugPrint('=== SERTIFIKAT STATUS: ${response.statusCode} ===');
    debugPrint('=== SERTIFIKAT BODY: ${response.body} ===');

    final decoded = _safeDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _extractMessage(decoded) ??
            'Gagal mengambil data sertifikat (${response.statusCode})',
      );
    }

    final rows = _extractRows(decoded);
    return rows.map(SertifikatModel.fromMap).toList();
  }

  Future<File> downloadCertificatePdf({
    required String filename,
    required String suggestedName,
  }) async {
    final cleanFilename = filename.replaceFirst(RegExp(r'^/+'), '');
    final encodedFilename = cleanFilename
        .split('/')
        .map(Uri.encodeComponent)
        .join('/');

    final url = '$_s3BaseUrl$encodedFilename';

    debugPrint('=== PDF DOWNLOAD URL: $url ===');

    final response = await http.get(
      Uri.parse(url),
      headers: const {
        'Accept': 'application/pdf,*/*',
      },
    );

    debugPrint('=== PDF STATUS: ${response.statusCode} ===');
    debugPrint('=== PDF CONTENT TYPE: ${response.headers['content-type']} ===');
    debugPrint('=== PDF BYTE LENGTH: ${response.bodyBytes.length} ===');

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        response.bodyBytes.isEmpty) {
      throw Exception('File PDF tidak bisa diunduh dari storage.');
    }

    final tempDir = await getTemporaryDirectory();
    final safeName = _sanitizeFileName(suggestedName);
    final file = File('${tempDir.path}/$safeName.pdf');

    await file.writeAsBytes(response.bodyBytes, flush: true);

    debugPrint('=== PDF SAVED PATH: ${file.path} ===');

    return file;
  }

  List<Map<String, dynamic>> _extractRows(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final rows = data['data'];
      if (rows is List) {
        return rows
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

  String _sanitizeFileName(String input) {
    return input
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(' ', '_');
  }
}