import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/hitung_pohon_job_model.dart';

class HitungPohonService {
  HitungPohonService({
    this.baseUrl = 'https://jubilant-knee-evergreen.ngrok-free.dev',
    this.apiKey = 'a',
    this.userId = 'anonymous',
  });

  static const Duration _requestTimeout = Duration(seconds: 25);

  final String baseUrl;
  final String apiKey;
  final String userId;

  Uri _uri(String path) {
    final clean = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return Uri.parse('$clean$path');
  }

  Map<String, String> get _headers => {
        'x-api-key': apiKey,
        'x-user-id': userId,
        'Accept': 'application/json',
      };

  Future<Map<String, dynamic>> checkConnection() async {
    final response = await http.get(_uri('/health')).timeout(_requestTimeout);
    return _extractMap(response, 'health');
  }

  Future<HitungPohonJobModel> uploadTif(File file) async {
    final request = http.MultipartRequest('POST', _uri('/detect'));
    request.headers.addAll(_headers);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send().timeout(_requestTimeout);
    final response = await http.Response.fromStream(streamed);
    final json = _extractMap(response, 'detect');
    return HitungPohonJobModel.fromJson(json);
  }

  Future<List<HitungPohonJobModel>> getHistory({
    String status = 'done',
    String? dateFrom,
    String? dateTo,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int limit = 50,
    int offset = 0,
  }) async {
    final now = DateTime.now();
    final defaultTo = dateTo ?? _dateOnly(now);
    final defaultFrom = dateFrom ?? _dateOnly(now.subtract(const Duration(days: 90)));

    final uri = _uri('/jobs').replace(
      queryParameters: {
        'status': status,
        'date_from': defaultFrom,
        'date_to': defaultTo,
        'sort_by': sortBy,
        'sort_order': sortOrder,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    final response = await http.get(uri, headers: _headers).timeout(_requestTimeout);
    final json = _extractMap(response, 'jobs');
    final data = json['data'];

    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => HitungPohonJobModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  String _dateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<HitungPohonJobModel> getJob(String id) async {
    final response = await http.get(_uri('/jobs/$id'), headers: _headers).timeout(_requestTimeout);
    final json = _extractMap(response, 'jobs/$id');
    return HitungPohonJobModel.fromJson(json);
  }

  Map<String, dynamic> _extractMap(http.Response response, String endpoint) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Request $endpoint gagal: ${response.statusCode} ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw Exception('Format response $endpoint tidak valid');
  }
}
