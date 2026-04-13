import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../providers/dashboard_provider.dart';
import '../widgets/article/article_section.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_menu_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DashboardProvider>();

    final allArticles = provider.allArticles;
    final dashboardArticles = provider.dashboardArticles;

    final menus = provider.buildMenus(
      onEHaraTap: () {},
      onRekomendasiTap: () {},
      onGanodermaTap: () {},
      onSertifikasiTap: () {},
    );

    return AppBackground(
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardHeader(
                      onNotificationTap: () {
                        context.push(AppRoutes.notifikasi);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Fitur E-Hara',
                      style: AppTextStyles.heading2(),
                    ),
                    const SizedBox(height: 12),
                    DashboardMenuSection(menus: menus),
                    const SizedBox(height: 24),
                    ArticleSection(
                      articles: dashboardArticles,
                      onArticleTap: (article) {
                        context.push(
                          AppRoutes.articleDetail,
                          extra: article,
                        );
                      },
                      onSeeMoreTap: () {
                        context.push(
                          AppRoutes.articleList,
                          extra: allArticles,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}