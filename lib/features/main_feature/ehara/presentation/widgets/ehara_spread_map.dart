import 'dart:math' as math;
import 'package:flutter/material.dart';

class EHaraSpreadMap extends StatelessWidget {
  final bool isPreview;

  const EHaraSpreadMap({
    super.key,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = isPreview ? 18.0 : 12.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: _EHaraSpreadPainter(
            isPreview: isPreview,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _EHaraSpreadPainter extends CustomPainter {
  final bool isPreview;

  _EHaraSpreadPainter({
    required this.isPreview,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 48.0;
    const rightPad = 18.0;
    const topPad = 24.0;
    const bottomPad = 42.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final borderPaint = Paint()
      ..color = const Color(0xFF444444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final gridPaint = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..strokeWidth = 1;

    canvas.drawRect(
      Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight),
      borderPaint,
    );

    final titlePainter = TextPainter(
      text: TextSpan(
        text: 'Sebaran',
        style: TextStyle(
          fontSize: isPreview ? 18 : 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF222222),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    titlePainter.paint(
      canvas,
      Offset(
        leftPad + chartWidth / 2 - titlePainter.width / 2,
        isPreview ? 4 : 8,
      ),
    );

    final xLabels = [
      '98.943',
      '98.944',
      '98.945',
      '98.946',
      '98.947',
      '98.948',
      '98.949',
      '98.950',
    ];

    final yLabels = [
      '3.5385',
      '3.5390',
      '3.5395',
      '3.5400',
      '3.5405',
    ];

    final axisStyle = TextStyle(
      fontSize: isPreview ? 10 : 14,
      color: const Color(0xFF333333),
    );

    for (int i = 0; i < yLabels.length; i++) {
      final t = i / (yLabels.length - 1);
      final y = topPad + chartHeight - (chartHeight * t);

      canvas.drawLine(
        Offset(leftPad, y),
        Offset(leftPad + chartWidth, y),
        gridPaint,
      );

      final tp = TextPainter(
        text: TextSpan(text: yLabels[i], style: axisStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(
          leftPad - tp.width - 8,
          y - tp.height / 2,
        ),
      );
    }

    for (int i = 0; i < xLabels.length; i++) {
      final t = i / (xLabels.length - 1);
      final x = leftPad + chartWidth * t;

      final tp = TextPainter(
        text: TextSpan(text: xLabels[i], style: axisStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(
          x - tp.width / 2,
          topPad + chartHeight + 6,
        ),
      );
    }

    final xAxisPainter = TextPainter(
      text: TextSpan(
        text: 'Longitude',
        style: TextStyle(
          fontSize: isPreview ? 11 : 16,
          color: const Color(0xFF222222),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    xAxisPainter.paint(
      canvas,
      Offset(
        leftPad + chartWidth / 2 - xAxisPainter.width / 2,
        size.height - xAxisPainter.height - 4,
      ),
    );

    final yAxisPainter = TextPainter(
      text: TextSpan(
        text: 'Latitude',
        style: TextStyle(
          fontSize: isPreview ? 11 : 16,
          color: const Color(0xFF222222),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(
      14,
      topPad + chartHeight / 2 + yAxisPainter.width / 2,
    );
    canvas.rotate(-math.pi / 2);
    yAxisPainter.paint(canvas, Offset.zero);
    canvas.restore();

    final pointPaint = Paint()
      ..color = const Color(0xFF2F80C5)
      ..style = PaintingStyle.fill;

    final points = <Offset>[];

    const rows = 47;
    const cols = 63;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final tx = col / (cols - 1);
        final ty = row / (rows - 1);

        final x = leftPad + chartWidth * tx;
        final y = topPad + chartHeight * ty;

        final leftBoundary = 0.02 + 0.03 * (1 - ty);
        final rightBoundary = 0.98 - 0.06 * ty;
        final topBoundary = 0.04 + 0.01 * math.sin(tx * math.pi * 2);
        final bottomBoundary = 0.97 - 0.01 * math.cos(tx * math.pi * 3);

        bool inside = tx >= leftBoundary &&
            tx <= rightBoundary &&
            ty >= topBoundary &&
            ty <= bottomBoundary;

        final centralGap = (tx > 0.43 && tx < 0.56 && ty > 0.05 && ty < 0.95);
        final centralSpine = (tx > 0.47 && tx < 0.51);
        final diagonalCutA = ((tx - 0.49).abs() < 0.015 + ty * 0.02);
        final diagonalCutB =
        ((tx - (0.49 + (ty - 0.5) * 0.12)).abs() < 0.014);
        final diagonalCutC =
        ((tx - (0.49 - (ty - 0.5) * 0.10)).abs() < 0.014);

        if (centralGap && (centralSpine || diagonalCutA || diagonalCutB || diagonalCutC)) {
          inside = false;
        }

        final lowerLeftHole = tx < 0.26 && ty > 0.58 && ((tx - 0.18) * (tx - 0.18) + (ty - 0.80) * (ty - 0.80) < 0.010);
        final midLeftHole = tx < 0.28 && ty > 0.32 && ty < 0.60 && ((tx - 0.16) * (tx - 0.16) + (ty - 0.48) * (ty - 0.48) < 0.009);
        final topCenterHole = tx > 0.34 && tx < 0.58 && ty < 0.22 && ((tx - 0.46) * (tx - 0.46) + (ty - 0.12) * (ty - 0.12) < 0.010);

        if (lowerLeftHole || midLeftHole || topCenterHole) {
          inside = false;
        }

        if (!inside) continue;

        points.add(Offset(x, y));
      }
    }

    final starRadius = isPreview ? 1.7 : 3.0;

    for (final point in points) {
      _drawStar(
        canvas,
        point,
        starRadius,
        pointPaint,
      );
    }
  }

  void _drawStar(
      Canvas canvas,
      Offset center,
      double radius,
      Paint paint,
      ) {
    final path = Path();
    const points = 5;
    final innerRadius = radius * 0.45;

    for (int i = 0; i < points * 2; i++) {
      final angle = -math.pi / 2 + i * math.pi / points;
      final r = i.isEven ? radius : innerRadius;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EHaraSpreadPainter oldDelegate) {
    return oldDelegate.isPreview != isPreview;
  }
}