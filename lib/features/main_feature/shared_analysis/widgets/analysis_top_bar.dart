import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/pressable_button.dart';

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
    final buttonSize = Responsive.w(context, 52);
    final pdfIconSize = Responsive.w(context, 30);

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

          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: PressableButton(
              onTap: onPdfTap,
              borderRadius: BorderRadius.circular(
                Responsive.r(context, 20),
              ),
              color: const Color(0xFFF9FAFB),
              border: Border.all(
                color: const Color(0xFF2F2F2F).withValues(alpha: 0.3),
                width: Responsive.w(context, 1.4),
              ),
              padding: EdgeInsets.all(Responsive.w(context, 10)),
              pressedScale: 0.96,
              pressedTranslateY: 1.2,
              idleTranslateY: -0.3,
              child: Image.asset(
                'assets/icons/csv.png',
                width: pdfIconSize,
                height: pdfIconSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}