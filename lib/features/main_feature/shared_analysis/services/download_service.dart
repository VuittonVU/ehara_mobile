import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../notifikasi/services/notifikasi_service.dart';
import '../../notifikasi/services/notifikasi_helper.dart';

class DownloadService {
  static Future<String> downloadToDownloadFolder({
    required String url,
    required WidgetRef ref,
    String fileName = 'file.csv',
  }) async {
    final permissionGranted = await _requestStoragePermission();

    if (!permissionGranted) {
      await LocalNotificationService.show(
        title: 'Download Gagal',
        body: 'Izin penyimpanan ditolak.',
      );

      NotificationHelper.push(
        ref,
        title: 'Download Gagal',
        message: 'Izin penyimpanan ditolak.',
      );

      throw Exception('Izin penyimpanan ditolak');
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Gagal download file (${response.statusCode})');
      }

      final safeFileName =
      fileName.endsWith('.csv') ? fileName : '$fileName.csv';

      final downloadDir = await _getDownloadDirectory();
      final eharaDir = Directory('${downloadDir.path}/EHARA');

      if (!await eharaDir.exists()) {
        await eharaDir.create(recursive: true);
      }

      final file = File('${eharaDir.path}/$safeFileName');
      await file.writeAsBytes(response.bodyBytes, flush: true);

      final title = _buildNotificationTitle(safeFileName);

      await LocalNotificationService.show(
        title: title,
        body: 'File berhasil diunduh. Cek folder Download.',
      );

      NotificationHelper.push(
        ref,
        title: title,
        message: 'File berhasil diunduh. Cek folder Download.',
      );

      return file.path;
    } catch (e) {
      await LocalNotificationService.show(
        title: 'Download Gagal',
        body: 'File tidak berhasil diunduh. Coba lagi.',
      );

      NotificationHelper.push(
        ref,
        title: 'Download Gagal',
        message: 'File tidak berhasil diunduh. Coba lagi.',
      );

      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  static String _buildNotificationTitle(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.contains('ganoderma')) {
      return 'CSV Ganoderma';
    }

    if (lower.contains('ehara') || lower.contains('hara')) {
      return 'CSV Unsur Hara';
    }

    return 'Download Selesai';
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