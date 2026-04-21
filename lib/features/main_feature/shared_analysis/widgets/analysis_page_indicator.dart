import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';

class AnalysisPageIndicator extends StatelessWidget {
  final int total;
  final int currentIndex;

  const AnalysisPageIndicator({
    super.key,
    required this.total,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 4),
          ),
          width: isActive
              ? Responsive.w(context, 34)
              : Responsive.w(context, 14),
          height: Responsive.h(context, 12),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF387867)
                : const Color(0xFFC8C8C8),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}