import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EharaApiService {
  EharaApiService({
    required this.baseUrl,
    required this.apiKey,
  });

  final String baseUrl;
  final String apiKey;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    return Uri.parse('$cleanBaseUrl$path').replace(
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{
      'x-api-key': apiKey,
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<List<dynamic>> getDatatable({
    required String queryName,
  }) async {
    final uri = _buildUri(
      '/api/mobile/datatable',
      {'query_name': queryName},
    );

    final response = await http.get(
      uri,
      headers: await _headers(),
    );

    return _extractListResponse(response, endpointName: 'datatable:$queryName');
  }

  Future<Map<String, dynamic>> getDashboardData({
    required String eharaUuid,
  }) async {
    final uri = _buildUri('/api/mobile/dashboard/get-dashboard-data');

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _headers());
    request.fields['e_hara_uuid'] = eharaUuid;

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    return _extractMapResponse(response, endpointName: 'get-dashboard-data');
  }

  Future<Map<String, dynamic>> getDashboardRecommendation({
    required String eharaUuid,
  }) async {
    final uri = _buildUri(
      '/api/mobile/dashboard/fertilizer-recommendation/get-data',
    );

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _headers());
    request.fields['e_hara_uuid'] = eharaUuid;

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    return _extractMapResponse(
      response,
      endpointName: 'fertilizer-recommendation/get-data',
    );
  }

  Future<Map<String, dynamic>> getDashboardGanoderma({
    required String eharaUuid,
  }) async {
    final uri = _buildUri('/api/mobile/dashboard/ganoderma/get-data');

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _headers());
    request.fields['e_hara_uuid'] = eharaUuid;

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    return _extractMapResponse(
      response,
      endpointName: 'ganoderma/get-data',
    );
  }

  List<dynamic> _extractListResponse(
      http.Response response, {
        required String endpointName,
      }) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Request failed [$endpointName]: ${response.statusCode} ${response.body}',
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

    throw Exception('Unexpected list response format for $endpointName');
  }

  Map<String, dynamic> _extractMapResponse(
      http.Response response, {
        required String endpointName,
      }) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Request failed [$endpointName]: ${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) return decoded;

    throw Exception('Unexpected map response format for $endpointName');
  }
}