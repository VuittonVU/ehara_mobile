import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widgets/app_background.dart';
import '../../data/notifikasi_data.dart';
import '../widgets/notifikasi_bubble.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationData.notifications;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => context.pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 38),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return NotificationBubble(
                      message: item.message,
                      dateTime: item.dateTime,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}