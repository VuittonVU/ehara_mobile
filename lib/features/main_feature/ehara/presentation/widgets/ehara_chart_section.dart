import 'package:flutter/material.dart';

class EHaraChartSection extends StatelessWidget {
  const EHaraChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _EHaraChartPainter(),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _LegendDot(color: Color(0xFF7FB6D8), label: 'Hasil'),
                  SizedBox(width: 18),
                  _LegendLine(color: Color(0xFFC68A1E), label: 'Standar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          ),
        ),
      ],
    );
  }
}

class _LegendLine extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendLine({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          ),
        ),
      ],
    );
  }
}

class _EHaraChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 30.0;
    const rightPad = 14.0;
    const topPad = 16.0;
    const bottomPad = 42.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final gridPaint = Paint()
      ..color = const Color(0xFFD8D8D8)
      ..strokeWidth = 1;

    final axisTextStyle = const TextStyle(
      fontSize: 10,
      color: Color(0xFF666666),
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i <= 3; i++) {
      final y = topPad + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(leftPad + chartWidth, y),
        gridPaint,
      );
    }

    final labels = ['N', 'P', 'K', 'Mg'];
    final hasil = [2.75, 0.10, 2.45, 0.06];
    final standar = [0.25, 1.05, 1.35, 0.12];
    final maxY = 3.0;

    final barPaint = Paint()..color = const Color(0xFFBFECEF);
    final linePaint = Paint()
      ..color = const Color(0xFFC68A1E)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    final xStep = chartWidth / labels.length;
    final barWidth = xStep * 0.52;

    final linePath = Path();

    for (int i = 0; i < labels.length; i++) {
      final centerX = leftPad + xStep * i + xStep / 2;
      final barHeight = (hasil[i] / maxY) * chartHeight;
      final barRect = Rect.fromLTWH(
        centerX - barWidth / 2,
        topPad + chartHeight - barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(barRect, const Radius.circular(2)),
        barPaint,
      );

      final lineY = topPad + chartHeight - (standar[i] / maxY) * chartHeight;
      if (i == 0) {
        linePath.moveTo(centerX, lineY);
      } else {
        linePath.lineTo(centerX, lineY);
      }

      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: axisTextStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(centerX - tp.width / 2, topPad + chartHeight + 8));
    }

    canvas.drawPath(linePath, linePaint);

    final yLabels = ['3.0', '2.0', '1.0', '0.0'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = topPad + (chartHeight / 3) * i;
      final tp = TextPainter(
        text: TextSpan(text: yLabels[i], style: axisTextStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}