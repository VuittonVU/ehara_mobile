import 'package:flutter/material.dart';

import '../../../shared/widgets/analysis_section_card.dart';

class EHaraStatusSection extends StatelessWidget {
  const EHaraStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisSectionCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: const Column(
        children: [
          _StatusRow(
            label: 'N',
            value: 2.27,
            minOptimal: 1.0,
            maxOptimal: 2.0,
            maxScale: 3.0,
            markerColor: Color(0xFF4E8C8A),
          ),
          SizedBox(height: 16),
          _StatusRow(
            label: 'P',
            value: 0.13,
            minOptimal: 1.0,
            maxOptimal: 2.0,
            maxScale: 3.0,
            markerColor: Color(0xFF4E8C8A),
          ),
          SizedBox(height: 16),
          _StatusRow(
            label: 'K',
            value: 0.75,
            minOptimal: 1.0,
            maxOptimal: 2.0,
            maxScale: 3.0,
            markerColor: Color(0xFF4E8C8A),
          ),
          SizedBox(height: 16),
          _StatusRow(
            label: 'Mg',
            value: 0.24,
            minOptimal: 1.0,
            maxOptimal: 2.0,
            maxScale: 3.0,
            markerColor: Color(0xFF4E8C8A),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final double value;
  final double minOptimal;
  final double maxOptimal;
  final double maxScale;
  final Color markerColor;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.minOptimal,
    required this.maxOptimal,
    required this.maxScale,
    required this.markerColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final labelWidth = label.length > 1 ? 34.0 : 24.0;
        final gap = 8.0;
        final barWidth = totalWidth - labelWidth - gap;
        final safeBarWidth = barWidth < 180 ? 180.0 : barWidth;

        final fraction = (value / maxScale).clamp(0.0, 1.0);
        final minStop = (minOptimal / maxScale).clamp(0.0, 1.0);
        final maxStop = (maxOptimal / maxScale).clamp(0.0, 1.0);

        final markerX = (safeBarWidth * fraction).clamp(10.0, safeBarWidth - 10.0);

        final topFont = safeBarWidth < 250 ? 8.0 : 9.5;
        final bubbleFont = safeBarWidth < 250 ? 10.0 : 11.0;
        final labelFont = label.length > 1 ? 16.0 : 18.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: labelWidth,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: labelFont,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFB58A2F),
                ),
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              child: SizedBox(
                width: safeBarWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 18,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: Text(
                                  '0.0',
                                  style: TextStyle(
                                    fontSize: topFont,
                                    color: const Color(0xFF6F6F6F),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: safeBarWidth * 0.28,
                                child: Text(
                                  'KURANG',
                                  style: TextStyle(
                                    fontSize: topFont,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFC28E78),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: safeBarWidth * 0.58,
                                child: Text(
                                  'OPTIMAL',
                                  style: TextStyle(
                                    fontSize: topFont,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF6C9A89),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 28,
                                child: Text(
                                  'B',
                                  style: TextStyle(
                                    fontSize: topFont,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFD2A553),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Text(
                                  maxScale.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: topFont,
                                    color: const Color(0xFF6F6F6F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          width: safeBarWidth,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1F000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: const [
                                Color(0xFFE5B291),
                                Color(0xFFE5B291),
                                Color(0xFFAEE3C2),
                                Color(0xFFAEE3C2),
                                Color(0xFFE8CF86),
                                Color(0xFFE8CF86),
                              ],
                              stops: [
                                0.0,
                                minStop,
                                minStop,
                                maxStop,
                                maxStop,
                                1.0,
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFFD0BD86),
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: markerX - 6,
                      top: 22,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: markerColor,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: (markerX - 22).clamp(0.0, safeBarWidth - 44.0),
                      top: -2,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 42),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          '${value.toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: bubbleFont,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF444444),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}