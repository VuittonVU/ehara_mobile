import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../list_kebun/models/kebun_feature_type.dart';
import '../../providers/dashboard_controller.dart';
import '../../../list_kebun/providers/kebun_selection_controller.dart';
import '../widgets/article/article_section.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_menu_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  void _goToListKebun(
      BuildContext context,
      WidgetRef ref,
      KebunFeatureType feature,
      ) {
    ref
        .read(kebunSelectionControllerProvider.notifier)
        .setSelectedFeature(feature);

    context.push(AppRoutes.listKebun);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(dashboardControllerProvider);

    final allArticles = provider.allArticles;
    final dashboardArticles = provider.dashboardArticles;

    final menus = provider.buildMenus(
      onEHaraTap: () {
        _goToListKebun(context, ref, KebunFeatureType.ehara);
      },
      onRekomendasiTap: () {
        _goToListKebun(
          context,
          ref,
          KebunFeatureType.rekomendasiPemupukan,
        );
      },
      onGanodermaTap: () {
        _goToListKebun(context, ref, KebunFeatureType.ganoderma);
      },
      onSertifikasiTap: () {
        context.push(AppRoutes.sertifikat);
      },
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