import 'package:flutter/material.dart';
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        return DashboardMenuItem(menu: menus[index]);
      },
    );
  }
}