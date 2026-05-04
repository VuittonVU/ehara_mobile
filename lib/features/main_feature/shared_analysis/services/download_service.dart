import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../notifikasi/services/notifikasi_helper.dart';
import '../../notifikasi/services/notifikasi_service.dart';

class DownloadService {
  static final MediaStore _mediaStore = MediaStore();

  static Future<String> downloadAndOpenFile({
    required String url,
    required WidgetRef ref,
    required String fileName,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          response.bodyBytes.isEmpty) {
        throw Exception('Gagal download file (${response.statusCode})');
      }

      final safeName = _safeFileName(fileName);
      final bytes = Uint8List.fromList(response.bodyBytes);

      final tempPath = await _saveToTemp(
        bytes: bytes,
        fileName: safeName,
      );

      String finalPath = tempPath;

      if (Platform.isAndroid) {
        final saveInfo = await _mediaStore.saveFile(
          tempFilePath: tempPath,
          dirType: DirType.download,
          dirName: DirName.download,
          relativePath: 'EHARA',
        );

        debugPrint('=== MEDIASTORE SAVE INFO: $saveInfo ===');

        final uri = saveInfo?.uri;

        if (uri != null) {
          finalPath = uri.toString();
        }
      }

      await OpenFilex.open(tempPath);

      await _notifySuccess(
        ref: ref,
        title: _buildNotificationTitle(safeName),
        message: 'File berhasil diunduh ke Download/EHARA.',
      );

      return finalPath;
    } catch (e) {
      await _notifyFailed(ref);
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  static Future<String> downloadToDownloadFolder({
    required String url,
    required WidgetRef ref,
    String fileName = 'file.csv',
    bool openAfterDownload = false,
    Map<String, String>? headers,
  }) async {
    if (openAfterDownload) {
      return downloadAndOpenFile(
        url: url,
        ref: ref,
        fileName: fileName,
        headers: headers,
      );
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          response.bodyBytes.isEmpty) {
        throw Exception('Gagal download file (${response.statusCode})');
      }

      final safeName = _safeFileName(fileName);

      final tempPath = await _saveToTemp(
        bytes: Uint8List.fromList(response.bodyBytes),
        fileName: safeName,
      );

      String finalPath = tempPath;

      if (Platform.isAndroid) {
        final saveInfo = await _mediaStore.saveFile(
          tempFilePath: tempPath,
          dirType: DirType.download,
          dirName: DirName.download,
          relativePath: 'EHARA',
        );

        debugPrint('=== MEDIASTORE SAVE INFO: $saveInfo ===');

        final uri = saveInfo?.uri;

        if (uri != null) {
          finalPath = uri.toString();
        }
      }

      await _notifySuccess(
        ref: ref,
        title: _buildNotificationTitle(safeName),
        message: 'File berhasil diunduh ke Download/EHARA.',
      );

      return finalPath;
    } catch (e) {
      await _notifyFailed(ref);
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  static Future<String> openFileOnly({
    required String url,
    required WidgetRef ref,
    required String fileName,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          response.bodyBytes.isEmpty) {
        throw Exception('Gagal membuka file (${response.statusCode})');
      }

      final safeName = _safeFileName(fileName);

      final path = await _saveToTemp(
        bytes: Uint8List.fromList(response.bodyBytes),
        fileName: safeName,
      );

      await OpenFilex.open(path);

      return path;
    } catch (e) {
      await _notifyFailed(ref);
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  static Future<String> _saveToTemp({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static String _safeFileName(String fileName) {
    final cleaned = fileName
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(' ', '_')
        .trim();

    if (cleaned.isEmpty) return 'file.csv';
    if (!cleaned.contains('.')) return '$cleaned.csv';

    return cleaned;
  }

  static String _buildNotificationTitle(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.contains('ganoderma')) return 'CSV Ganoderma';

    if (lower.contains('ehara') || lower.contains('hara')) {
      return 'CSV Unsur Hara';
    }

    if (lower.contains('sertifikat') || lower.endsWith('.pdf')) {
      return 'Sertifikat PDF';
    }

    return 'Download Selesai';
  }

  static Future<void> _notifySuccess({
    required WidgetRef ref,
    required String title,
    required String message,
  }) async {
    await LocalNotificationService.show(
      title: title,
      body: message,
    );

    NotificationHelper.push(
      ref,
      title: title,
      message: message,
    );
  }

  static Future<void> _notifyFailed(WidgetRef ref) async {
    await LocalNotificationService.show(
      title: 'Download Gagal',
      body: 'File tidak berhasil diunduh.',
    );

    NotificationHelper.push(
      ref,
      title: 'Download Gagal',
      message: 'File tidak berhasil diunduh.',
    );
  }
}