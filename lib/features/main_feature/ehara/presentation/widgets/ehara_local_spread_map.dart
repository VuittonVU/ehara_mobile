import 'dart:math' as math;
import 'package:flutter/material.dart';

class EHaraLocalSpreadMap extends StatelessWidget {
  final bool fullScreen;

  const EHaraLocalSpreadMap({
    super.key,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetAspectRatio = 1.02;

        double width = constraints.maxWidth;
        double height = width / targetAspectRatio;

        if (height > constraints.maxHeight) {
          height = constraints.maxHeight;
          width = height * targetAspectRatio;
        }

        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: _EHaraLocalSpreadPainter(
                fullScreen: fullScreen,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EHaraLocalSpreadPainter extends CustomPainter {
  final bool fullScreen;

  _EHaraLocalSpreadPainter({
    required this.fullScreen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = fullScreen ? 54.0 : 42.0;
    final rightPad = fullScreen ? 16.0 : 12.0;
    final topPad = fullScreen ? 32.0 : 26.0;
    final bottomPad = fullScreen ? 44.0 : 34.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final frameRect = Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight);

    final borderPaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final gridPaint = Paint()
      ..color = const Color(0xFFD8D8D8)
      ..strokeWidth = 1.0;

    canvas.drawRect(frameRect, borderPaint);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: 'Sebaran',
        style: TextStyle(
          fontSize: fullScreen ? 22 : 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF202020),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    titlePainter.paint(
      canvas,
      Offset(
        leftPad + chartWidth / 2 - titlePainter.width / 2,
        fullScreen ? 4 : 2,
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

    final axisTextStyle = TextStyle(
      fontSize: fullScreen ? 13 : 9,
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
        text: TextSpan(text: yLabels[i], style: axisTextStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(leftPad - tp.width - (fullScreen ? 10 : 6), y - tp.height / 2),
      );
    }

    for (int i = 0; i < xLabels.length; i++) {
      final t = i / (xLabels.length - 1);
      final x = leftPad + chartWidth * t;

      final tp = TextPainter(
        text: TextSpan(text: xLabels[i], style: axisTextStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(
          x - tp.width / 2,
          topPad + chartHeight + (fullScreen ? 8 : 6),
        ),
      );
    }

    final xAxisPainter = TextPainter(
      text: TextSpan(
        text: 'Longitude',
        style: TextStyle(
          fontSize: fullScreen ? 16 : 11,
          color: const Color(0xFF222222),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    xAxisPainter.paint(
      canvas,
      Offset(
        leftPad + chartWidth / 2 - xAxisPainter.width / 2,
        size.height - xAxisPainter.height - 2,
      ),
    );

    final yAxisPainter = TextPainter(
      text: TextSpan(
        text: 'Latitude',
        style: TextStyle(
          fontSize: fullScreen ? 16 : 11,
          color: const Color(0xFF222222),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(
      fullScreen ? 16 : 12,
      topPad + chartHeight / 2 + yAxisPainter.width / 2,
    );
    canvas.rotate(-math.pi / 2);
    yAxisPainter.paint(canvas, Offset.zero);
    canvas.restore();

    final pointPaint = Paint()
      ..color = const Color(0xFF2F80C5)
      ..style = PaintingStyle.fill;

    final points = _generateWebLikePoints(frameRect);

    final radius = fullScreen ? 3.2 : 1.9;
    for (final point in points) {
      _drawStar(canvas, point, radius, pointPaint);
    }
  }

  List<Offset> _generateWebLikePoints(Rect frameRect) {
    final points = <Offset>[];

    const rows = 44;
    const cols = 66;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final tx = col / (cols - 1);
        final ty = row / (rows - 1);

        double px = frameRect.left + frameRect.width * tx;
        double py = frameRect.top + frameRect.height * ty;

        final offsetX = (row.isEven ? 0.0 : frameRect.width * 0.004);
        px += offsetX;

        // outer shape: hampir penuh, sedikit trapezoid/gelombang seperti web
        final leftEdge = 0.03 + 0.01 * ty;
        final rightEdge = 0.97 - 0.05 * ty + 0.01 * math.sin(ty * 4.0);
        final topEdge = 0.03 + 0.01 * math.sin(tx * math.pi * 1.2);
        final bottomEdge = 0.97 - 0.02 * math.sin(tx * math.pi * 3.4).abs();

        bool inside = tx >= leftEdge &&
            tx <= rightEdge &&
            ty >= topEdge &&
            ty <= bottomEdge;

        if (!inside) continue;

        // vertical/diagonal central white corridor like web
        final center = 0.49 + 0.015 * math.sin(ty * math.pi * 2.8);
        final gapWidth = 0.028 + 0.008 * math.cos(ty * math.pi * 2.0).abs();
        final inMainCorridor = (tx - center).abs() < gapWidth;

        final branchA = ty < 0.24 &&
            tx > 0.40 &&
            tx < 0.58 &&
            (tx - (0.47 + ty * 0.12)).abs() < 0.020;

        final branchB = ty > 0.18 &&
            ty < 0.62 &&
            (tx - (0.50 - (ty - 0.20) * 0.10)).abs() < 0.016;

        final branchC = ty > 0.52 &&
            (tx - (0.47 + (ty - 0.52) * 0.06)).abs() < 0.014;

        if (inMainCorridor || branchA || branchB || branchC) {
          continue;
        }

        // irregular sparse holes mostly left/bottom like web
        final hole1 = _ellipse(tx, ty, 0.11, 0.79, 0.07, 0.07);
        final hole2 = _ellipse(tx, ty, 0.18, 0.66, 0.06, 0.06);
        final hole3 = _ellipse(tx, ty, 0.21, 0.84, 0.05, 0.05);

        if (hole1 || hole2 || hole3) continue;

        // deterministic sparse missing points
        final noiseA = ((row * 17 + col * 31) % 97) == 0;
        final noiseB = ((row * 13 + col * 19) % 89) == 0;
        final noiseC = tx < 0.42 &&
            ty > 0.38 &&
            ty < 0.90 &&
            ((row * 7 + col * 11) % 37 == 0);

        if (noiseA || noiseB || noiseC) continue;

        points.add(Offset(px, py));
      }
    }

    return points;
  }

  bool _ellipse(
      double x,
      double y,
      double cx,
      double cy,
      double rx,
      double ry,
      ) {
    final dx = (x - cx) / rx;
    final dy = (y - cy) / ry;
    return dx * dx + dy * dy < 1.0;
  }

  void _drawStar(
      Canvas canvas,
      Offset center,
      double radius,
      Paint paint,
      ) {
    final path = Path();
    const points = 5;
    final innerRadius = radius * 0.46;

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
  bool shouldRepaint(covariant _EHaraLocalSpreadPainter oldDelegate) {
    return oldDelegate.fullScreen != fullScreen;
  }
}