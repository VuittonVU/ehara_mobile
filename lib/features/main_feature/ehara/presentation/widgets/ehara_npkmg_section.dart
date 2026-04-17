import 'package:flutter/material.dart';

import '../../../shared/widgets/analysis_section_card.dart';

class EHaraNpkmgSection extends StatelessWidget {
  const EHaraNpkmgSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisSectionCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: SizedBox(
        width: double.infinity,
        height: 240,
        child: CustomPaint(
          painter: _NpkmgPainter(),
        ),
      ),
    );
  }
}

class _NpkmgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const rightPad = 14.0;
    const topPad = 12.0;
    const bottomPad = 34.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final gridPaint = Paint()
      ..color = const Color(0xFFD8D8D8)
      ..strokeWidth = 1;

    for (int i = 0; i <= 3; i++) {
      final y = topPad + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(leftPad + chartWidth, y),
        gridPaint,
      );
    }

    const values = [2.27, 0.13, 0.75, 0.24];
    const labels = ['N', 'P', 'K', 'Mg'];
    const maxY = 3.0;

    final barPaint = Paint()..color = const Color(0xFF18733D);

    const valueStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color(0xFF9A5F1F),
    );

    const labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF666666),
    );

    const axisStyle = TextStyle(
      fontSize: 10,
      color: Color(0xFF666666),
    );

    final xStep = chartWidth / labels.length;
    final barWidth = xStep * 0.58;

    for (int i = 0; i < labels.length; i++) {
      final centerX = leftPad + xStep * i + xStep / 2;
      final barHeight = (values[i] / maxY) * chartHeight;

      final rect = Rect.fromLTWH(
        centerX - barWidth / 2,
        topPad + chartHeight - barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRect(rect, barPaint);

      final valuePainter = TextPainter(
        text: TextSpan(text: values[i].toString(), style: valueStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      valuePainter.paint(
        canvas,
        Offset(centerX - valuePainter.width / 2, rect.top - 18),
      );

      final labelPainter = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(centerX - labelPainter.width / 2, topPad + chartHeight + 10),
      );
    }

    const yLabels = ['3.0', '2.0', '1.0', '0.0'];

    for (int i = 0; i < yLabels.length; i++) {
      final y = topPad + (chartHeight / 3) * i;
      final tp = TextPainter(
        text: TextSpan(text: yLabels[i], style: axisStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}