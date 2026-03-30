import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///LOGO
        Image.asset(
          'assets/images/logo/logo_ehara.png',
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),

        ///NOTIFICATION BUTTON
        InkWell(
          onTap: onNotificationTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.75),
                width: 1,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/bell.png',
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}