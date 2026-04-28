import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/app_background.dart';
import 'analysis_page_indicator.dart';
import 'analysis_top_bar.dart';

class AnalysisPageShell extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onDownloadTap;
  final List<Widget> children;
  final int totalIndicators;
  final int currentIndicator;

  const AnalysisPageShell({
    super.key,
    required this.title,
    this.onBackTap,
    this.onDownloadTap,
    required this.children,
    required this.totalIndicators,
    required this.currentIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              0,
              0,
              0,
              Responsive.h(context, 24) + bottomSafeArea,
            ),
            child: Column(
              children: [
                AnalysisTopBar(
                  title: title,
                  onBackTap: onBackTap,
                  onDownloadTap: onDownloadTap,
                ),
                SizedBox(height: Responsive.h(context, 14)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(context, 18),
                  ),
                  child: Column(
                    children: children,
                  ),
                ),
                SizedBox(height: Responsive.h(context, 24)),
                AnalysisPageIndicator(
                  total: totalIndicators,
                  currentIndex: currentIndicator,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}