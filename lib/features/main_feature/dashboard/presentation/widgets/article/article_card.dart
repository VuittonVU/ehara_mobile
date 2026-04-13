import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../models/article_model.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  article.imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.medium(
                fontSize: 12.5,
              ).copyWith(height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}