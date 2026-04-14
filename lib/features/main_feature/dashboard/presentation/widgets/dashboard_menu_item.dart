import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
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
      borderRadius: BorderRadius.circular(28),
      color: Colors.white.withOpacity(0.92),
      border: Border.all(
        color: AppColors.textPrimary.withOpacity(0.12),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconBoxSize =
          (constraints.maxWidth * 0.48).clamp(64.0, 80.0);
          final iconSize =
          (iconBoxSize * 0.55).clamp(34.0, 44.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 ICON BOX
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFD2E7BA),
                  borderRadius: BorderRadius.circular(22),
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

              const SizedBox(height: 8),

              // 🔹 TITLE
              Text(
                menu.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium(
                  color: AppColors.primary,
                ).copyWith(
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}