class NotificationSettingsState {
  final bool isNotificationEnabled;

  const NotificationSettingsState({
    required this.isNotificationEnabled,
  });

  factory NotificationSettingsState.initial() {
    return const NotificationSettingsState(
      isNotificationEnabled: false,
    );
  }

  NotificationSettingsState copyWith({
    bool? isNotificationEnabled,
  }) {
    return NotificationSettingsState(
      isNotificationEnabled:
      isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }
}