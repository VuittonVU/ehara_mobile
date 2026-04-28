enum NotificationType {
  security,
  certificate,
  payment,
  download,
  analysis,
  general,
}

class NotificationModel {
  final String title;
  final String message;
  final String dateTime;
  final NotificationType type;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.dateTime,
    required this.type,
  });
}