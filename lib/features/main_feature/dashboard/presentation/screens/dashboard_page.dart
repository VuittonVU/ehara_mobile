import 'package:flutter/material.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../../core/widgets/app_bottom_navbar.dart';
import '../../models/article_model.dart';
import '../../models/dashboard_menu_model.dart';
import '../widgets/article_section.dart';
import '../widgets/dashboard_greeting_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_menu_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArticleModel> articles = [
      const ArticleModel(
        title:
        'Performa Random Forest Untuk Klasifikasi Penyakit Busuk Pangkal Batang Yang Disebabkan Oleh Ganoderma Boninense Pada Perkebunan Kelapa Sawit',
        imagePath: 'assets/images/articles/img1.png',
        date: '11 Nov 2024',
      ),
      const ArticleModel(
        title:
        'Eksplorasi Pendugaan Hara Daun Tanaman Kelapa Sawit Menggunakan Pesawat Tanpa Awak Dan Kamera Multispektral',
        imagePath: 'assets/images/articles/img2.png',
        date: '04 Nov 2024',
      ),
      const ArticleModel(
        title:
        'Pemetaan Kandungan Hara Daun Kelapa Sawit Menggunakan Citra Multispektral Berbasis Unmanned Aerial Vehicle',
        imagePath: 'assets/images/articles/img3.png',
        date: '04 Nov 2024',
      ),
    ];

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
        currentIndex: 0, // dashboard
        onTapHome: () {},
        onTapRiwayat: () {
          Navigator.pushNamed(context, '/riwayat');
        },
        onTapTambahAnalisis: () {
          Navigator.pushNamed(context, '/tambah-analisis');
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
                        onNotificationTap: () {},
                      ),
                      const SizedBox(height: 20),
                      const DashboardGreetingCard(
                        userName: 'User',
                      ),
                      const SizedBox(height: 20),
                      DashboardMenuSection(menus: menus),
                      const SizedBox(height: 20),
                      ArticleSection(
                        articles: articles,
                        onSeeMoreTap: () {},
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