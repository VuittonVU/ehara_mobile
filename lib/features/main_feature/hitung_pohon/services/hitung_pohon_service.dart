import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/hitung_pohon_job_model.dart';

class HitungPohonService {
  HitungPohonService({
    this.baseUrl = 'http://45.77.168.172:8000',
    this.apiKey = 'a',
    this.userId = 'anonymous',
  });

  static const Duration _requestTimeout = Duration(seconds: 10);

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
    final request = http.MultipartRequest('POST', _uri('/detect/tif'));
    request.headers.addAll(_headers);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send().timeout(_requestTimeout);
    final response = await http.Response.fromStream(streamed);
    final json = _extractMap(response, 'detect/tif');
    return HitungPohonJobModel.fromJson(json);
  }

  Future<List<HitungPohonJobModel>> getHistory() async {
    final response = await http.get(_uri('/jobs'), headers: _headers).timeout(_requestTimeout);
    final json = _extractMap(response, 'jobs');
    final data = json['data'];

    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => HitungPohonJobModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
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
