import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../providers/dashboard_provider.dart';
import '../widgets/article/article_section.dart';
import '../widgets/dashboard_greeting_card.dart';
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

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardHeader(
                        onNotificationTap: () {
                          context.push(AppRoutes.notifikasi);
                        },
                      ),
                      const SizedBox(height: 20),
                      const DashboardGreetingCard(userName: 'User'),
                      const SizedBox(height: 20),
                      DashboardMenuSection(menus: menus),
                      const SizedBox(height: 20),
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
      ),
    );
  }
}