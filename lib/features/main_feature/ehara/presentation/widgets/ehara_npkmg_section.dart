import 'package:flutter/material.dart';

import '../../models/ehara_model.dart';
import '../../../shared_analysis/widgets/analysis_section_card.dart';

class EHaraNpkmgSection extends StatelessWidget {
  final EHaraModel dashboard;

  const EHaraNpkmgSection({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    final chartHeight = MediaQuery.of(context).size.width * 0.6;
    final isSmall = MediaQuery.of(context).size.width < 360;

    return AnalysisSectionCard(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 10 : 14,
        isSmall ? 10 : 14,
        isSmall ? 10 : 14,
        isSmall ? 10 : 14,
      ),
      child: SizedBox(
        width: double.infinity,
        height: chartHeight,
        child: CustomPaint(
          painter: _NpkmgPainter(
            values: [
              dashboard.nValue,
              dashboard.pValue,
              dashboard.kValue,
              dashboard.mgValue,
            ],
          ),
        ),
      ),
    );
  }
}

class _NpkmgPainter extends CustomPainter {
  final List<double> values;

  _NpkmgPainter({
    required this.values,
  });

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
      final value = i < values.length ? values[i] : 0.0;
      final centerX = leftPad + xStep * i + xStep / 2;
      final barHeight = (value / maxY).clamp(0.0, 1.0) * chartHeight;

      final rect = Rect.fromLTWH(
        centerX - barWidth / 2,
        topPad + chartHeight - barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRect(rect, barPaint);

      final valuePainter = TextPainter(
        text: TextSpan(text: value.toStringAsFixed(2), style: valueStyle),
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
  bool shouldRepaint(covariant _NpkmgPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}