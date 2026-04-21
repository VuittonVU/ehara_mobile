import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';

class AnalysisSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const AnalysisSectionCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          EdgeInsets.fromLTRB(
            Responsive.w(context, 20),
            Responsive.h(context, 20),
            Responsive.w(context, 20),
            Responsive.h(context, 20),
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.r(context, radius),
        ),
        border: Border.all(
          color: const Color(0xFFC9C9C9),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x22000000),
            blurRadius: Responsive.w(context, 10),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}