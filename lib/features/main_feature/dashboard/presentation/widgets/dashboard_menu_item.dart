import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/pressable_button.dart';
import '../../models/dashboard_menu_model.dart';

class DashboardMenuItem extends StatelessWidget {
  final DashboardMenuModel menu;

  const DashboardMenuItem({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return PressableButton(
      onTap: menu.onTap,
      borderRadius: BorderRadius.circular(
        Responsive.r(context, 24),
      ),
      color: Colors.white.withOpacity(0.92),
      border: Border.all(
        color: AppColors.textPrimary.withOpacity(0.12),
        width: 1,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 12),
        vertical: Responsive.h(context, 14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconBoxSize =
          (constraints.maxWidth * 0.42).clamp(
            Responsive.w(context, 56),
            Responsive.w(context, 76),
          );

          final iconSize =
          (iconBoxSize * 0.52).clamp(
            Responsive.w(context, 28),
            Responsive.w(context, 38),
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFD2E7BA),
                  borderRadius: BorderRadius.circular(
                    Responsive.r(context, 22),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: Image.asset(
                      menu.iconPath,
                      color: AppColors.primary,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(context, 8)),
              Text(
                menu.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium(
                  color: AppColors.primary,
                ).copyWith(
                  fontSize: Responsive.sp(context, 13),
                  height: 1.15,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}