import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/app_background.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../models/article_model.dart';
import '../../widgets/article/article_list_item.dart';
import 'article_detail_page.dart';

class ArticleListPage extends StatelessWidget {
  final List<ArticleModel> articles;

  const ArticleListPage({
    super.key,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = Responsive.isCompact(context);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Responsive.w(context, isCompact ? 16 : 22),
              Responsive.h(context, 15),
              Responsive.w(context, isCompact ? 16 : 22),
              Responsive.h(context, 28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ArticleHeader(
                  onBackTap: () => Navigator.pop(context),
                ),
                SizedBox(height: Responsive.h(context, 26)),
                Text(
                  'Telusuri Berita Terbaru Dari Kami',
                  style: AppTextStyles.medium(
                    fontSize: Responsive.sp(context, isCompact ? 16.5 : 18),
                    color: AppColors.textPrimary,
                  ).copyWith(
                    height: 1.25,
                  ),
                ),
                SizedBox(height: Responsive.h(context, 12)),
                Text(
                  'Bersama Kami, Anda Dapat Memiliki Program Untuk Membantu Mengatur Lahan Pertanian Sawit Anda Agar Lebih Baik',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textPrimary.withValues(alpha: 0.72),
                  ).copyWith(
                    fontSize: Responsive.sp(context, isCompact ? 12 : 13),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: Responsive.h(context, 24)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    Responsive.w(context, isCompact ? 14 : 18),
                    Responsive.h(context, isCompact ? 18 : 22),
                    Responsive.w(context, isCompact ? 14 : 18),
                    Responsive.h(context, isCompact ? 22 : 28),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(
                      Responsive.r(context, isCompact ? 26 : 34),
                    ),
                    border: Border.all(
                      color: AppColors.textPrimary.withValues(alpha: 0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: Responsive.w(context, 8),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ...List.generate(
                        articles.length,
                            (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == articles.length - 1
                                ? 0
                                : Responsive.h(context, 24),
                          ),
                          child: ArticleListItem(
                            article: articles[index],
                            onTapReadMore: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ArticleDetailPage(
                                    article: articles[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(context, 30)),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Copyright © 2026 ',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.textPrimary.withValues(alpha: 0.82),
                      ).copyWith(
                        fontSize: Responsive.sp(context, isCompact ? 11.5 : 12.5),
                      ),
                      children: [
                        TextSpan(
                          text: 'PPKS',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.textPrimary.withValues(alpha: 0.82),
                          ).copyWith(
                            fontSize: Responsive.sp(context, isCompact ? 11.5 : 12.5),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const _ArticleHeader({
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = Responsive.isCompact(context);

    return SizedBox(
      height: Responsive.h(context, 42),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBackTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Image.asset(
                'assets/icons/arrow_back.png',
                width: Responsive.w(context, isCompact ? 24 : 28),
                height: Responsive.h(context, isCompact ? 24 : 30),
              ),
            ),
          ),
          Text(
            'Artikel',
            style: AppTextStyles.semiBold(
              fontSize: Responsive.sp(context, isCompact ? 21 : 24),
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}