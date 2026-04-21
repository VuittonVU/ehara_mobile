import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/responsive.dart';
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
    final isCompact = Responsive.isCompact(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        Responsive.r(context, 16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Responsive.r(context, 14),
                ),
                child: Image.asset(
                  article.imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.medium(
                fontSize: Responsive.sp(context, isCompact ? 11.5 : 12.5),
              ).copyWith(
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}