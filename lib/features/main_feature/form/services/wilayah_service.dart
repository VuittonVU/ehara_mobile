import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/wilayah_item.dart';

class WilayahService {
  static const String _baseUrl = 'https://sipedas.pertanian.go.id/api/wilayah';

  static const Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<List<WilayahItem>> fetchProvinsi() async {
    return _fetch('$_baseUrl/index?lvl=11');
  }

  Future<List<WilayahItem>> fetchKabupaten({
    required String provinceCode,
  }) async {
    return _fetch('$_baseUrl/index?lvl=12&pro=$provinceCode');
  }

  Future<List<WilayahItem>> fetchKecamatan({
    required String provinceCode,
    required String kabupatenCode,
  }) async {
    return _fetch('$_baseUrl/index?lvl=13&pro=$provinceCode&kab=$kabupatenCode');
  }

  Future<List<WilayahItem>> _fetch(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      debugPrint('URL: $url');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('CONTENT-TYPE: ${response.headers['content-type']}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('HTTP Error: ${response.statusCode}');
      }

      final body = response.body.trim();

      if (!body.startsWith('[') && !body.startsWith('{')) {
        throw Exception('Response bukan JSON');
      }

      return _parseList(body);
    } catch (e) {
      debugPrint('FETCH ERROR: $e');
      throw Exception('Gagal mengambil data: $e');
    }
  }

  List<WilayahItem> _parseList(String body) {
    final decoded = jsonDecode(body);
    final rawList = _extractList(decoded);

    return rawList
        .map<WilayahItem>((item) {
      final map = item is Map<String, dynamic>
          ? item
          : Map<String, dynamic>.from(item as Map);
      return WilayahItem.fromJson(map);
    })
        .where((e) => e.code.isNotEmpty && e.name.isNotEmpty)
        .toList();
  }

  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;

    if (decoded is Map<String, dynamic>) {
      for (final key in ['data', 'result', 'results', 'value', 'values', 'wilayah']) {
        if (decoded[key] is List) return decoded[key] as List;
      }
    }

    return [];
  }
}