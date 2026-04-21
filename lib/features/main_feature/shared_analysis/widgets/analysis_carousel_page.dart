import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/app_background.dart';
import 'analysis_page_indicator.dart';
import 'analysis_top_bar.dart';

class AnalysisCarouselPage extends StatefulWidget {
  final List<String> titles;
  final List<Widget> slides;
  final VoidCallback? onBackTap;
  final VoidCallback? onPdfTap;
  final int initialIndex;

  const AnalysisCarouselPage({
    super.key,
    required this.titles,
    required this.slides,
    this.onBackTap,
    this.onPdfTap,
    this.initialIndex = 0,
  });

  @override
  State<AnalysisCarouselPage> createState() => _AnalysisCarouselPageState();
}

class _AnalysisCarouselPageState extends State<AnalysisCarouselPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AnalysisTopBar(
                title: widget.titles[_currentIndex],
                onBackTap: widget.onBackTap,
                onPdfTap: widget.onPdfTap,
              ),
              SizedBox(height: Responsive.h(context, 14)),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        Responsive.w(context, 18),
                        0,
                        Responsive.w(context, 18),
                        Responsive.h(context, 8) + bottomSafeArea,
                      ),
                      child: widget.slides[index],
                    );
                  },
                ),
              ),
              SizedBox(height: Responsive.h(context, 10)),
              AnalysisPageIndicator(
                total: widget.slides.length,
                currentIndex: _currentIndex,
              ),
              SizedBox(height: Responsive.h(context, 18) + bottomSafeArea),
            ],
          ),
        ),
      ),
    );
  }
}