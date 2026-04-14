import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/widgets/app_background.dart';
import '../../../providers/side_features/notification_settings/notification_settings_controller.dart';
import '../../widgets/profile_header.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationSettingsControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              ProfileHeader(
                title: 'Notifikasi',
                onBackTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFCFCFCF),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.isNotificationEnabled
                              ? 'Notifikasi Aktif'
                              : 'Notifikasi Mati',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3A3A3A),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.1,
                        child: Switch(
                          value: state.isNotificationEnabled,
                          onChanged: (value) {
                            ref
                                .read(
                              notificationSettingsControllerProvider.notifier,
                            )
                                .setNotification(value);
                          },
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xFF3E7F69),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0xFF7B7B7B),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Copyright © 2026 PPKS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}