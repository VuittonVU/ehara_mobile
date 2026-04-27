import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static Future<String> downloadToDownloadFolder({
    required String url,
    String fileName = 'file.csv',
  }) async {
    final permissionGranted = await _requestStoragePermission();

    if (!permissionGranted) {
      throw Exception('Izin penyimpanan ditolak');
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal download file (${response.statusCode})');
    }

    final safeFileName = fileName.endsWith('.csv') ? fileName : '$fileName.csv';

    final downloadDir = await _getDownloadDirectory();
    final eharaDir = Directory('${downloadDir.path}/EHARA');

    if (!await eharaDir.exists()) {
      await eharaDir.create(recursive: true);
    }

    final file = File('${eharaDir.path}/$safeFileName');

    await file.writeAsBytes(response.bodyBytes);

    return file.path;
  }

  static Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final sdkInt = await _androidSdkInt();

    if (sdkInt >= 33) {
      return true;
    }

    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<int> _androidSdkInt() async {
    try {
      final file = File('/system/build.prop');

      if (!await file.exists()) {
        return 33;
      }

      final content = await file.readAsString();
      final match = RegExp(r'ro\.build\.version\.sdk=(\d+)').firstMatch(content);

      return int.tryParse(match?.group(1) ?? '') ?? 33;
    } catch (_) {
      return 33;
    }
  }

  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');

      if (await directory.exists()) {
        return directory;
      }
    }

    return getApplicationDocumentsDirectory();
  }
}