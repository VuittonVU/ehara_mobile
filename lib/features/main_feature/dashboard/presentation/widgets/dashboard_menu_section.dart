import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../models/dashboard_menu_model.dart';
import 'dashboard_menu_item.dart';

class DashboardMenuSection extends StatelessWidget {
  final List<DashboardMenuModel> menus;

  const DashboardMenuSection({
    super.key,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: menus
            .map(
              (menu) => Expanded(
            child: DashboardMenuItem(menu: menu),
          ),
        )
            .toList(),
      ),
    );
  }
}