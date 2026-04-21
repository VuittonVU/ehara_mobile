import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';

class AnalysisTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onPdfTap;

  const AnalysisTopBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.onPdfTap,
  });

  @override
  Widget build(BuildContext context) {
    final sideBox = Responsive.w(context, 42);
    final pdfBox = Responsive.w(context, 58);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.w(context, 18),
        Responsive.h(context, 14),
        Responsive.w(context, 18),
        Responsive.h(context, 8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBackTap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: sideBox,
              height: sideBox,
              child: Center(
                child: Image.asset(
                  'assets/icons/arrow_back.png',
                  width: Responsive.w(context, 24),
                  height: Responsive.w(context, 24),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: Responsive.h(context, 6)),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 22),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF333333),
                  height: 1.0,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onPdfTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: pdfBox,
              height: pdfBox,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Responsive.r(context, 16),
                ),
                border: Border.all(
                  color: const Color(0xFF8C8C8C),
                  width: 1,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/download.png',
                  width: Responsive.w(context, 30),
                  height: Responsive.w(context, 30),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}