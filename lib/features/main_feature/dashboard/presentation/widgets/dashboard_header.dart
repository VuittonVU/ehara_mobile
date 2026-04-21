import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/pressable_button.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidth = Responsive.w(context, 78);
    final buttonSize = Responsive.w(context, 52);
    final iconSize = Responsive.w(context, 20);

    return Row(
      children: [
        Image.asset(
          'assets/images/logo/logo_ehara.png',
          width: logoWidth,
        ),

        const Spacer(),

        Padding(
          padding: EdgeInsets.only(right: Responsive.w(context, 2)), // 🔥 biar lebih kanan dikit
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: PressableButton(
              onTap: onNotificationTap,
              borderRadius: BorderRadius.circular(
                Responsive.r(context, 20),
              ),
              color: const Color(0xFFF9FAFB),
              border: Border.all(
                color: const Color(0xFF2F2F2F).withValues(alpha: 0.3),
                width: Responsive.w(context, 1.4),
              ),
              padding: EdgeInsets.all(Responsive.w(context, 12)),
              pressedScale: 0.96,
              pressedTranslateY: 1.2,
              idleTranslateY: -0.3,
              child: Image.asset(
                'assets/icons/notification.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}