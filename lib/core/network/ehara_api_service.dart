import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_headers.dart';

class EharaApiService {
  EharaApiService({
    required this.baseUrl,
    String? apiKey,
  }) : apiKey = apiKey ?? ApiHeaders.apiKey;

  final String baseUrl;
  final String apiKey;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'ehara_auth_token';

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Uri buildUri(String path, [Map<String, String>? queryParameters]) {
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    return Uri.parse('$cleanBaseUrl$path').replace(
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, String>> headers({bool withAuth = true}) async {
    if (withAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        return ApiHeaders.withToken(token);
      }
    }

    return ApiHeaders.noAuth();
  }

  Future<List<dynamic>> getDatatable({
    required String queryName,
  }) async {
    final uri = buildUri(
      '/api/mobile/datatable',
      {'query_name': queryName},
    );

    final response = await http.get(
      uri,
      headers: await headers(),
    );

    return _extractListResponse(response, endpointName: 'datatable:$queryName');
  }

  Future<Map<String, dynamic>> getDashboardData({
    required String eharaUuid,
  }) async {
    return postMultipart(
      path: '/api/mobile/dashboard/get-dashboard-data',
      fields: {'e_hara_uuid': eharaUuid},
      endpointName: 'get-dashboard-data',
    );
  }

  Future<Map<String, dynamic>> getDashboardRecommendation({
    required String eharaUuid,
  }) async {
    return postMultipart(
      path: '/api/mobile/dashboard/fertilizer-recommendation/get-data',
      fields: {'e_hara_uuid': eharaUuid},
      endpointName: 'fertilizer-recommendation/get-data',
    );
  }

  Future<Map<String, dynamic>> getDashboardGanoderma({
    required String eharaUuid,
  }) async {
    return postMultipart(
      path: '/api/mobile/dashboard/ganoderma/get-data',
      fields: {'e_hara_uuid': eharaUuid},
      endpointName: 'ganoderma/get-data',
    );
  }

  Future<Map<String, dynamic>> postMultipart({
    required String path,
    required Map<String, String> fields,
    Map<String, String>? filePaths,
    bool withAuth = true,
    String? endpointName,
  }) async {
    final uri = buildUri(path);
    final name = endpointName ?? path;
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await headers(withAuth: withAuth));
    request.fields.addAll(fields);

    if (filePaths != null) {
      for (final entry in filePaths.entries) {
        if (entry.value.trim().isEmpty) continue;
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value),
        );
      }
    }

    _logRequest(name, uri, request.headers, request.fields, filePaths);

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      _logResponse(name, response);
      return _extractMapResponse(response, endpointName: name);
    } catch (e, stackTrace) {
      debugPrint('=== EHARA API EXCEPTION [$name] ===');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }

  void _logRequest(
    String endpointName,
    Uri uri,
    Map<String, String> headers,
    Map<String, String> fields,
    Map<String, String>? filePaths,
  ) {
    debugPrint('=== EHARA API REQUEST [$endpointName] ===');
    debugPrint('URL: $uri');
    debugPrint('HEADERS: ${_redactHeaders(headers)}');
    debugPrint('FIELDS: $fields');
    if (filePaths != null && filePaths.isNotEmpty) {
      debugPrint('FILES: $filePaths');
    }
  }

  void _logResponse(String endpointName, http.Response response) {
    debugPrint('=== EHARA API RESPONSE [$endpointName] ===');
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');
  }

  Map<String, String> _redactHeaders(Map<String, String> headers) {
    final copy = Map<String, String>.from(headers);
    if (copy['Authorization'] != null) {
      final value = copy['Authorization']!;
      copy['Authorization'] = value.length > 18
          ? '${value.substring(0, 18)}...'
          : 'Bearer ...';
    }
    return copy;
  }

  List<dynamic> _extractListResponse(
    http.Response response, {
    required String endpointName,
  }) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _extractMessage(_safeDecode(response.body)) ??
            'Request gagal [$endpointName]: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) return decoded;

    if (decoded is Map<String, dynamic>) {
      final candidates = [
        decoded['data'],
        decoded['results'],
        decoded['rows'],
        decoded['items'],
        decoded['records'],
      ];

      for (final value in candidates) {
        if (value is List) return value;
      }
    }

    throw Exception('Format response list tidak sesuai untuk $endpointName');
  }

  Map<String, dynamic> _extractMapResponse(
    http.Response response, {
    required String endpointName,
  }) {
    final decoded = _safeDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _extractMessage(decoded) ??
            'Request gagal [$endpointName]: ${response.statusCode}',
      );
    }

    return decoded;
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return {'data': decoded};
    } catch (_) {
      return {'raw': body};
    }
  }

  String? _extractMessage(Map<String, dynamic> json) {
    final candidates = [
      json['message'],
      json['error'],
      json['errors'],
      if (json['meta'] is Map) (json['meta'] as Map)['message'],
      if (json['data'] is Map) (json['data'] as Map)['message'],
    ];

    for (final value in candidates) {
      if (value == null) continue;
      if (value is String && value.trim().isNotEmpty) return value;
      if (value is List && value.isNotEmpty) return value.join(', ');
      if (value is Map && value.isNotEmpty) {
        return value.values
            .expand((item) => item is List ? item : [item])
            .map((item) => item.toString())
            .join(', ');
      }
    }

    return null;
  }
}
