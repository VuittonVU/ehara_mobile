import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
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
    final isTablet = Responsive.isTablet(context);
    final isCompact = Responsive.isCompact(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: Responsive.w(context, isCompact ? 10 : 14),
        mainAxisSpacing: Responsive.h(context, isCompact ? 10 : 14),
        childAspectRatio: isTablet ? 1.25 : (isCompact ? 1.18 : 1.28),
      ),
      itemBuilder: (context, index) {
        return DashboardMenuItem(menu: menus[index]);
      },
    );
  }
}