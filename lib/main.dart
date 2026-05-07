import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_store_plus/media_store_plus.dart';

import 'app/app.dart';
import 'features/main_feature/notifikasi/services/notifikasi_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebaseSafely();

  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
    MediaStore.appFolder = 'EHARA';

    await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true,
    );
  }

  LocalNotificationService.init().catchError((e) {
    debugPrint('Local notification init error: $e');
  });

  runApp(
    const ProviderScope(
      child: EHaraApp(),
    ),
  );
}

Future<void> _initializeFirebaseSafely() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      debugPrint('Firebase already initialized, skip duplicate init.');
      return;
    }

    rethrow;
  } catch (e) {
    debugPrint('Firebase init error: $e');
    rethrow;
  }
}