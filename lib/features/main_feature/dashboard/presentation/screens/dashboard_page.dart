import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/routes/app_routes.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_bottom_navbar.dart';

import '../../data/article_data.dart';
import '../../models/article_model.dart';
import '../../models/dashboard_menu_model.dart';

import 'article/article_detail_page.dart';
import 'article/article_list_page.dart';

import '../widgets/article/article_section.dart';
import '../widgets/dashboard_greeting_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_menu_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArticleModel> allArticles = ArticleData.allArticles;
    final List<ArticleModel> dashboardArticles = ArticleData.dashboardArticles;

    final List<DashboardMenuModel> menus = [
      DashboardMenuModel(
        title: 'e-Hara',
        iconPath: 'assets/icons/leaf.png',
        onTap: () {},
      ),
      DashboardMenuModel(
        title: 'Rekomendasi\nPemupukan',
        iconPath: 'assets/icons/sprout.png',
        onTap: () {},
      ),
      DashboardMenuModel(
        title: 'Ganoderma',
        iconPath: 'assets/icons/map.png',
        onTap: () {},
      ),
      DashboardMenuModel(
        title: 'Sertifikasi',
        iconPath: 'assets/icons/badge_check.png',
        onTap: () {},
      ),
    ];

    return Scaffold(
      bottomNavigationBar: AppBottomNavbar(
        currentIndex: 0,
        onTapHome: () {},
        onTapRiwayat: () {
          Navigator.pushNamed(context, '/riwayat');
        },
        onTapTambahAnalisis: () {
          context.push(AppRoutes.form1);
        },
        onTapPembayaran: () {
          Navigator.pushNamed(context, '/pembayaran');
        },
        onTapProfile: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
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
                      const DashboardGreetingCard(
                        userName: 'User',
                      ),
                      const SizedBox(height: 20),
                      DashboardMenuSection(menus: menus),
                      const SizedBox(height: 20),
                      ArticleSection(
                        articles: dashboardArticles,
                        onArticleTap: (article) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArticleDetailPage(article: article),
                            ),
                          );
                        },
                        onSeeMoreTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArticleListPage(articles: allArticles),
                            ),
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