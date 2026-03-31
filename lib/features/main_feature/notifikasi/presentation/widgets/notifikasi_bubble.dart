import 'package:flutter/material.dart';

class NotificationBubble extends StatelessWidget {
  final String message;
  final String dateTime;

  const NotificationBubble({
    super.key,
    required this.message,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBDBDBD),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2F2F2F),
            ),
          ),
          const SizedBox(height: 12),
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
    );
  }
}