import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_background.dart';
import 'analysis_page_indicator.dart';
import 'analysis_top_bar.dart';

class AnalysisPageShell extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onPdfTap;
  final List<Widget> children;
  final int totalIndicators;
  final int currentIndicator;

  const AnalysisPageShell({
    super.key,
    required this.title,
    this.onBackTap,
    this.onPdfTap,
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
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30 + bottomSafeArea),
            child: Column(
              children: [
                AnalysisTopBar(
                  title: title,
                  onBackTap: onBackTap,
                  onPdfTap: onPdfTap,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: children,
                  ),
                ),
                const SizedBox(height: 26),
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