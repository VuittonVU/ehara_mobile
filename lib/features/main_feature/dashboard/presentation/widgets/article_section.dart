import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../models/article_model.dart';
import 'article_card.dart';

class ArticleSection extends StatelessWidget {
  final List<ArticleModel> articles;
  final VoidCallback onSeeMoreTap;

  const ArticleSection({
    super.key,
    required this.articles,
    required this.onSeeMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.22),
              ),
            ),
            child: Text(
              'Artikel',
              style: AppTextStyles.labelLarge(),
            ),
          ),
          const SizedBox(height: 20),
          ...articles.map(
                (article) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: ArticleCard(article: article),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: onSeeMoreTap,
              child: Text(
                'Baca Artikel Selengkapnya ->',
                style: AppTextStyles.caption(
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}