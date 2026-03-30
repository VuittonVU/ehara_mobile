import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../models/dashboard_menu_model.dart';

class DashboardMenuItem extends StatelessWidget {
  final DashboardMenuModel menu;

  const DashboardMenuItem({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: menu.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              child: Center(
                child: Image.asset(
                  menu.iconPath,
                  width: 24,
                  height: 24,
                  color: AppColors.primary,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              menu.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption(),
            ),
          ],
        ),
      ),
    );
  }
}