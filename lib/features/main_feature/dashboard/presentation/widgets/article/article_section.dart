import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
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
          Text(
            'Artikel',
            style: AppTextStyles.heading3(),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onPanDown: (_) => _pauseTemporarily(),
            onHorizontalDragStart: (_) => _pauseTemporarily(),
            child: AspectRatio(
              aspectRatio: 16 / 8,
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
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _visibleArticles.length,
                  (index) {
                final isActive = index == _currentVisualIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
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
          const SizedBox(height: 6),
          Center(
            child: InkWell(
              onTap: widget.onSeeMoreTap,
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