import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notifikasi_model.dart';
import '../providers/notifikasi_controller.dart';

class NotificationHelper {
  static void push(
      WidgetRef ref, {
        required String title,
        required String message,
        NotificationType type = NotificationType.download,
      }) {
    final now = DateTime.now();
    final formatted =
        '${now.day}/${now.month}/${now.year} • ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    ref.read(notificationControllerProvider.notifier).add(
      NotificationModel(
        title: title,
        message: message,
        dateTime: formatted,
        type: type,
      ),
    );
  }
}