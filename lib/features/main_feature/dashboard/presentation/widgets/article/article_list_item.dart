import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/responsive.dart';
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
    final isCompact = Responsive.isCompact(context);

    final titleFontSize = Responsive.sp(context, isCompact ? 11.5 : 12.5);
    final dateFontSize = Responsive.sp(context, isCompact ? 9.5 : 10.5);
    final readMoreFontSize = Responsive.sp(context, isCompact ? 10 : 11);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Responsive.r(context, 12),
          ),
          child: AspectRatio(
            aspectRatio: isCompact ? 16 / 9.2 : 16 / 7.8,
            child: Image.asset(
              article.imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: Responsive.h(context, 14)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semiBold(
                  fontSize: titleFontSize,
                  color: AppColors.textPrimary,
                ).copyWith(
                  height: 1.3,
                ),
              ),
              SizedBox(height: Responsive.h(context, 8)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Responsive.h(context, 2),
                      ),
                      child: Text(
                        article.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall(
                          color: AppColors.textPrimary.withOpacity(0.45),
                        ).copyWith(
                          fontSize: dateFontSize,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(context, 10)),
                  Flexible(
                    child: InkWell(
                      onTap: onTapReadMore,
                      borderRadius: BorderRadius.circular(
                        Responsive.r(context, 8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(context, 2),
                          vertical: Responsive.h(context, 2),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Baca Artikel Selengkapnya →',
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.medium(
                              fontSize: Responsive.sp(context, isCompact ? 11 : 12.5),
                              color: AppColors.accent,
                            ).copyWith(
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}