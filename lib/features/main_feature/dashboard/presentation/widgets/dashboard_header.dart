import 'package:flutter/material.dart';

import '../../../../../core/widgets/pressable_button.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo/logo_ehara.png',
          width: 78,
          fit: BoxFit.cover,
        ),
        const Spacer(),
        SizedBox(
          width: 52,
          height: 52,
          child: PressableButton(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFF9FAFB),
            border: Border.all(
              color: const Color(0xFF2F2F2F).withOpacity(0.3),
              width: 1.4,
            ),
            padding: const EdgeInsets.all(12),
            pressedScale: 0.96,
            pressedTranslateY: 1.2,
            idleTranslateY: -0.3,
            child: Image.asset(
              'assets/icons/notification.png',
              width: 20,
              height: 20,
            ),
          )
        ),
      ],
    );
  }
}