import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBackTap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Image.asset(
                  'assets/icons/arrow_back.png',
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF333333),
                  height: 1.0,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onPdfTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8C8C8C),
                  width: 1,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/download.png',
                  width: 34,
                  height: 34,
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