import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notifikasi_model.dart';

final notificationControllerProvider =
StateNotifierProvider<NotificationController, List<NotificationModel>>(
      (ref) => NotificationController(),
);

class NotificationController extends StateNotifier<List<NotificationModel>> {
  NotificationController() : super([]);

  void add(NotificationModel item) {
    state = [item, ...state];
  }

  void clear() {
    state = [];
  }
}