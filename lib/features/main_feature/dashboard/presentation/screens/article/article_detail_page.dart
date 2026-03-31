import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/app_background.dart';
import '../../../models/article_model.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailPage({
    super.key,
    required this.article,
  });

  Future<void> _launchSourceUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link tidak dapat dibuka'),
        ),
      );
    }
  }

  Widget _buildContentText(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: AppTextStyles.bodySmall(
        color: AppColors.textPrimary.withValues(alpha: 0.8),
      ).copyWith(
        height: 1.7,
      ),
    );
  }

  Widget _buildTableImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Detail Artikel',
                        style: AppTextStyles.semiBold(
                          fontSize: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.textPrimary.withValues(alpha: 0.14),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: AppTextStyles.semiBold(
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: AspectRatio(
                              aspectRatio: 16 / 8.5,
                              child: Image.asset(
                                article.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.date,
                            style: AppTextStyles.caption(
                              color: AppColors.textPrimary.withValues(alpha: 0.45),
                            ).copyWith(
                              fontSize: 12,
                            ),
                          ),

                          if (article.content1.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            _buildContentText(article.content1),
                          ],

                          if (article.tableImagePath1 != null &&
                              article.tableImagePath1!.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            _buildTableImage(article.tableImagePath1!),
                          ],

                          if (article.content2.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            _buildContentText(article.content2),
                          ],

                          if (article.tableImagePath2 != null &&
                              article.tableImagePath2!.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            _buildTableImage(article.tableImagePath2!),
                          ],

                          if (article.content3.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            _buildContentText(article.content3),
                          ],

                          if (article.sourceLabel != null &&
                              article.sourceLabel!.isNotEmpty &&
                              article.sourceUrl != null &&
                              article.sourceUrl!.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Sumber:',
                              style: AppTextStyles.caption(
                                color: AppColors.textPrimary.withValues(alpha: 0.55),
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.textPrimary.withValues(alpha: 0.78),
                                ).copyWith(
                                  height: 1.6,
                                ),
                                children: [
                                  TextSpan(
                                    text: article.sourceLabel!,
                                    style: AppTextStyles.bodySmall(
                                      color: AppColors.primary,
                                    ).copyWith(
                                      height: 1.6,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchSourceUrl(
                                          context,
                                          article.sourceUrl!,
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}