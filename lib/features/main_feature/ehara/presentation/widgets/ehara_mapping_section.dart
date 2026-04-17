import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../shared/widgets/analysis_primary_button.dart';
import '../../../shared/widgets/analysis_section_card.dart';

class EHaraMappingSection extends StatelessWidget {
  const EHaraMappingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnalysisSectionCard(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: SizedBox(
            width: double.infinity,
            height: 260,
            child: CustomPaint(
              painter: _ScatterPainter(),
            ),
          ),
        ),
        const SizedBox(height: 18),
        AnalysisPrimaryButton(
          label: 'Lihat Peta',
          onTap: () => context.push(AppRoutes.eharaFullMap),
        ),
      ],
    );
  }
}

class _ScatterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 42.0;
    const rightPad = 14.0;
    const topPad = 20.0;
    const bottomPad = 26.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final borderPaint = Paint()
      ..color = const Color(0xFF8B8B8B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..strokeWidth = 1;

    canvas.drawRect(Offset.zero & size, borderPaint);

    final titlePainter = TextPainter(
      text: const TextSpan(
        text: 'Sebaran',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    titlePainter.paint(
      canvas,
      Offset(size.width / 2 - titlePainter.width / 2, 2),
    );

    final xLabels = [
      '99.1095',
      '99.1097',
      '99.1099',
      '99.1101',
      '99.1103',
      '99.1105',
    ];

    final yLabels = [
      '3.2242',
      '3.2240',
      '3.2238',
      '3.2236',
      '3.2234',
      '3.2232',
      '3.2230',
      '3.2228',
    ];

    for (int i = 0; i < yLabels.length; i++) {
      final y = topPad + (chartHeight / (yLabels.length - 1)) * i;

      canvas.drawLine(
        Offset(leftPad, y),
        Offset(leftPad + chartWidth, y),
        gridPaint,
      );

      final tp = TextPainter(
        text: TextSpan(
          text: yLabels[i],
          style: const TextStyle(
            fontSize: 8,
            color: Color(0xFF555555),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(4, y - tp.height / 2));
    }

    for (int i = 0; i < xLabels.length; i++) {
      final x = leftPad + (chartWidth / (xLabels.length - 1)) * i;

      final tp = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: const TextStyle(
            fontSize: 8,
            color: Color(0xFF555555),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(x - tp.width / 2, topPad + chartHeight + 6));
    }

    const axisStyle = TextStyle(
      fontSize: 9,
      color: Color(0xFF555555),
    );

    final xAxisPainter = TextPainter(
      text: const TextSpan(text: 'Longitude', style: axisStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    xAxisPainter.paint(
      canvas,
      Offset(
        leftPad + chartWidth / 2 - xAxisPainter.width / 2,
        size.height - 12,
      ),
    );

    final yAxisPainter = TextPainter(
      text: const TextSpan(text: 'Latitude', style: axisStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(10, topPad + chartHeight / 2 + yAxisPainter.width / 2);
    canvas.rotate(-1.5708);
    yAxisPainter.paint(canvas, Offset.zero);
    canvas.restore();

    final pointPaint = Paint()
      ..color = const Color(0xFF2F7CC9)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2;

    final points = <Offset>[];

    for (int y = 0; y < 18; y++) {
      for (int x = 0; x < 22; x++) {
        final dx = leftPad + 14 + x * 10.8 + (y.isEven ? 0 : 3);
        final dy = topPad + 12 + y * 9.8;

        final relativeX = (dx - leftPad) / chartWidth;
        final relativeY = (dy - topPad) / chartHeight;

        final insideShape = relativeX > 0.05 &&
            relativeX < 0.96 &&
            relativeY > 0.05 &&
            relativeY < 0.92 &&
            relativeY > (0.92 - relativeX * 0.8);

        if (insideShape) {
          points.add(Offset(dx, dy));
        }
      }
    }

    for (final point in points) {
      canvas.drawPoints(PointMode.points, [point], pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}