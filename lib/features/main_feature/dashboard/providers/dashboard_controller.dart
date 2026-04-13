import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/article_data.dart';
import '../models/article_model.dart';
import '../models/dashboard_menu_model.dart';

final dashboardControllerProvider = Provider<DashboardController>((ref) {
  return DashboardController();
});

class DashboardController {
  List<ArticleModel> get allArticles => ArticleData.allArticles;

  List<ArticleModel> get dashboardArticles => ArticleData.dashboardArticles;

  List<DashboardMenuModel> buildMenus({
    required VoidCallback onEHaraTap,
    required VoidCallback onRekomendasiTap,
    required VoidCallback onGanodermaTap,
    required VoidCallback onSertifikasiTap,
  }) {
    return [
      DashboardMenuModel(
        title: 'e-Hara',
        iconPath: 'assets/icons/leaf.png',
        onTap: onEHaraTap,
      ),
      DashboardMenuModel(
        title: 'Pemupukan',
        iconPath: 'assets/icons/sprout.png',
        onTap: onRekomendasiTap,
      ),
      DashboardMenuModel(
        title: 'Ganoderma',
        iconPath: 'assets/icons/map.png',
        onTap: onGanodermaTap,
      ),
      DashboardMenuModel(
        title: 'Sertifikasi',
        iconPath: 'assets/icons/badge_check.png',
        onTap: onSertifikasiTap,
      ),
    ];
  }
}