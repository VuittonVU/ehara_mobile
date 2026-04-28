import 'package:flutter/material.dart';

import '../../models/notifikasi_model.dart';

class NotificationBubble extends StatelessWidget {
  final String title;
  final String message;
  final String dateTime;
  final NotificationType type;

  const NotificationBubble({
    super.key,
    required this.title,
    required this.message,
    required this.dateTime,
    required this.type,
  });

  IconData get _icon {
    switch (type) {
      case NotificationType.security:
        return Icons.shield_outlined;
      case NotificationType.certificate:
        return Icons.workspace_premium_outlined;
      case NotificationType.payment:
        return Icons.payments_outlined;
      case NotificationType.download:
        return Icons.file_download_done_outlined;
      case NotificationType.analysis:
        return Icons.analytics_outlined;
      case NotificationType.general:
        return Icons.notifications_none_rounded;
    }
  }

  Color get _color {
    switch (type) {
      case NotificationType.security:
        return const Color(0xFFD65A31);
      case NotificationType.certificate:
        return const Color(0xFF3E806D);
      case NotificationType.payment:
        return const Color(0xFF7A5AF8);
      case NotificationType.download:
        return const Color(0xFF2F80ED);
      case NotificationType.analysis:
        return const Color(0xFF219653);
      case NotificationType.general:
        return const Color(0xFF555555);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon,
              size: 21,
              color: _color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    dateTime,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8D8D8D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}