import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../models/article_model.dart';

class ArticleListItem extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTapReadMore;

  const ArticleListItem({
    super.key,
    required this.article,
    required this.onTapReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 7.3,
            child: Image.asset(
              article.imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: AppTextStyles.semiBold(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      article.date,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.textPrimary.withValues(alpha: 0.45),
                      ).copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: onTapReadMore,
                    child: Text(
                      'Baca Artikel Selengkapnya ->',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.medium(
                        fontSize: 13,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}