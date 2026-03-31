import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/app_background.dart';
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
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 15, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ArticleHeader(
                  onBackTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 30),
                Text(
                  'Telusuri Berita Terbaru Dari Kami',
                  style: AppTextStyles.medium(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bersama Kami, Anda Dapat Memiliki Program Untuk Membantu\nMengatur Lahan Pertanian Sawit Anda Agar Lebih Baik',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textPrimary.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: AppColors.textPrimary.withValues(alpha: 0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
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
                            bottom: index == articles.length - 1 ? 0 : 26,
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
                const SizedBox(height: 34),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Copyright © 2026 ',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.textPrimary.withValues(alpha: 0.82),
                      ),
                      children: [
                        TextSpan(
                          text: 'PPKS',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.textPrimary.withValues(alpha: 0.82),
                          ).copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: onBackTap,
            borderRadius: BorderRadius.circular(24),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 34,
                color: Colors.black,
              ),
            ),
          ),
        ),

        Text(
          'Artikel',
          style: AppTextStyles.semiBold(
            fontSize: 24,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}