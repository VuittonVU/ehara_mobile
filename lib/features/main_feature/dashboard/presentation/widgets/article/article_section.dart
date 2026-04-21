import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../models/article_model.dart';
import 'article_card.dart';

class ArticleSection extends StatefulWidget {
  final List<ArticleModel> articles;
  final VoidCallback onSeeMoreTap;
  final ValueChanged<ArticleModel> onArticleTap;

  const ArticleSection({
    super.key,
    required this.articles,
    required this.onSeeMoreTap,
    required this.onArticleTap,
  });

  @override
  State<ArticleSection> createState() => _ArticleSectionState();
}

class _ArticleSectionState extends State<ArticleSection> {
  static const int _loopBase = 1000;

  late PageController _pageController;
  Timer? _timer;
  bool _userInteracting = false;
  int _pageIndex = 0;

  List<ArticleModel> get _visibleArticles => widget.articles.take(3).toList();

  int get _initialPage {
    final length = _visibleArticles.length;
    if (length <= 1) return 0;
    return _loopBase * length;
  }

  int get _currentVisualIndex {
    final length = _visibleArticles.length;
    if (length == 0) return 0;
    return _pageIndex % length;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _initialPage,
    );
    _pageIndex = _initialPage;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    _timer?.cancel();

    if (_visibleArticles.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients || _userInteracting) return;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseTemporarily() {
    _userInteracting = true;
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      _userInteracting = false;
    });
  }

  @override
  void didUpdateWidget(covariant ArticleSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.articles.length != widget.articles.length) {
      _timer?.cancel();
      _pageController.dispose();

      _pageController = PageController(
        initialPage: _initialPage,
      );
      _pageIndex = _initialPage;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
        _startAutoSlide();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleArticles.isEmpty) {
      return const SizedBox.shrink();
    }

    final isCompact = Responsive.isCompact(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Responsive.w(context, 18),
        Responsive.h(context, 15),
        Responsive.w(context, 18),
        Responsive.h(context, 15),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(
          Responsive.r(context, 28),
        ),
        border: Border.all(
          color: AppColors.textPrimary.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: Responsive.w(context, 8),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 4),
            ),
            child: Text(
              'Artikel',
              style: AppTextStyles.titleMedium().copyWith(
                fontSize: Responsive.sp(context, 16),
              ),
            ),
          ),
          SizedBox(height: Responsive.h(context, 10)),
          GestureDetector(
            onPanDown: (_) => _pauseTemporarily(),
            onHorizontalDragStart: (_) => _pauseTemporarily(),
            child: AspectRatio(
              aspectRatio: isCompact ? 14 / 9.2 : 15 / 8,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final article =
                  _visibleArticles[index % _visibleArticles.length];
                  return ArticleCard(
                    article: article,
                    onTap: () => widget.onArticleTap(article),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: Responsive.h(context, 9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _visibleArticles.length,
                  (index) {
                final isActive = index == _currentVisualIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: Responsive.w(context, 8),
                  height: Responsive.w(context, 8),
                  margin: EdgeInsets.symmetric(
                    horizontal: Responsive.w(context, 3),
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF8A8A8A)
                        : const Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Responsive.h(context, 9)),
          Center(
            child: InkWell(
              onTap: widget.onSeeMoreTap,
              borderRadius: BorderRadius.circular(
                Responsive.r(context, 8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(context, 6),
                  vertical: Responsive.h(context, 4),
                ),
                child: Text(
                  isCompact
                      ? 'Baca Artikel\nSelengkapnya ->'
                      : 'Baca Artikel Selengkapnya ->',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(
                    color: AppColors.accent,
                  ).copyWith(
                    fontSize: Responsive.sp(context, isCompact ? 10.5 : 11),
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}