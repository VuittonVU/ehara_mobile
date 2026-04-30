import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_store_plus/media_store_plus.dart';

import 'app/app.dart';
import 'features/main_feature/notifikasi/services/notifikasi_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MediaStore.ensureInitialized();

  MediaStore.appFolder = 'EHARA';

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  await LocalNotificationService.init();

  runApp(
    const ProviderScope(
      child: EHaraApp(),
    ),
  );
}