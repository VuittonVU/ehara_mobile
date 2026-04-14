import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_settings_state.dart';

final notificationSettingsControllerProvider = StateNotifierProvider.autoDispose<
    NotificationSettingsController, NotificationSettingsState>(
      (ref) => NotificationSettingsController(),
);

class NotificationSettingsController
    extends StateNotifier<NotificationSettingsState> {
  NotificationSettingsController()
      : super(NotificationSettingsState.initial());

  void setNotification(bool value) {
    state = state.copyWith(isNotificationEnabled: value);
  }

  void toggleNotification() {
    state = state.copyWith(
      isNotificationEnabled: !state.isNotificationEnabled,
    );
  }
}