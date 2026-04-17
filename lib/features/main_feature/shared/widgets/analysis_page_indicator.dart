import 'package:flutter/material.dart';

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
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 40 : 16,
          height: 16,
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