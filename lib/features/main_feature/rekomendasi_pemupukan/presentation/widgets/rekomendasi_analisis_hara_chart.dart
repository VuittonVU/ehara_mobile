import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../shared_analysis/widgets/analysis_section_card.dart';

class RekomendasiAnalisisHaraChart extends StatefulWidget {
  final List<double> hasil;
  final List<double> standar;

  const RekomendasiAnalisisHaraChart({
    super.key,
    required this.hasil,
    required this.standar,
  });

  @override
  State<RekomendasiAnalisisHaraChart> createState() =>
      _RekomendasiAnalisisHaraChartState();
}

class _RekomendasiAnalisisHaraChartState
    extends State<RekomendasiAnalisisHaraChart> {
  int? _hoveredIndex;
  Offset? _hoverPosition;

  static const _labels = ['N', 'P', 'K', 'Mg'];
  static const _maxY = 3.0;

  void _updateHover(Offset localPosition, Size size) {
    const leftPad = 36.0;
    const rightPad = 14.0;
    const topPad = 16.0;
    const bottomPad = 42.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final insideChart = localPosition.dx >= leftPad &&
        localPosition.dx <= leftPad + chartWidth &&
        localPosition.dy >= topPad &&
        localPosition.dy <= topPad + chartHeight;

    if (!insideChart) {
      if (_hoveredIndex != null || _hoverPosition != null) {
        setState(() {
          _hoveredIndex = null;
          _hoverPosition = null;
        });
      }
      return;
    }

    final xStep = chartWidth / _labels.length;
    final rawIndex = ((localPosition.dx - leftPad) / xStep).floor();
    final index = rawIndex.clamp(0, _labels.length - 1);

    setState(() {
      _hoveredIndex = index;
      _hoverPosition = localPosition;
    });
  }

  String _statusText(int index) {
    final diff = widget.hasil[index] - widget.standar[index];
    if (diff >= 0.5) return 'Sangat Baik';
    if (diff >= 0.0) return 'Cukup';
    if (diff <= -0.8) return 'Sangat Kurang';
    return 'Kurang';
  }

  Color _statusColor(int index) {
    final diff = widget.hasil[index] - widget.standar[index];
    if (diff >= 0.0) return const Color(0xFF4CAF50);
    if (diff <= -0.8) return const Color(0xFFE35D5D);
    return const Color(0xFFE39A25);
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    final chartHeight = isSmall ? 232.0 : 250.0;

    return AnalysisSectionCard(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 10 : 12,
        isSmall ? 10 : 12,
        isSmall ? 10 : 12,
        isSmall ? 10 : 12,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartSize = Size(constraints.maxWidth, chartHeight);

          return MouseRegion(
            opaque: true,
            cursor: SystemMouseCursors.click,
            onHover: (event) => _updateHover(event.localPosition, chartSize),
            onExit: (_) {
              setState(() {
                _hoveredIndex = null;
                _hoverPosition = null;
              });
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) => _updateHover(details.localPosition, chartSize),
              child: SizedBox(
                height: chartHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        size: chartSize,
                        painter: _AnalisisChartPainter(
                          labels: _labels,
                          hasil: widget.hasil,
                          standar: widget.standar,
                          maxY: _maxY,
                        ),
                      ),
                    ),
                    if (_hoveredIndex != null && _hoverPosition != null)
                      _HoverInfoCard(
                        chartSize: chartSize,
                        position: _hoverPosition!,
                        label: _labels[_hoveredIndex!],
                        hasil: widget.hasil[_hoveredIndex!],
                        standar: widget.standar[_hoveredIndex!],
                        status: _statusText(_hoveredIndex!),
                        statusColor: _statusColor(_hoveredIndex!),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HoverInfoCard extends StatelessWidget {
  final Size chartSize;
  final Offset position;
  final String label;
  final double hasil;
  final double standar;
  final String status;
  final Color statusColor;

  const _HoverInfoCard({
    required this.chartSize,
    required this.position,
    required this.label,
    required this.hasil,
    required this.standar,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    final diff = hasil - standar;
    final cardWidth = isSmall ? 144.0 : 160.0;

    final left = math.min(
      math.max(12.0, position.dx + 12),
      chartSize.width - cardWidth - 12,
    );
    final top = math.min(
      math.max(10.0, position.dy - (isSmall ? 92 : 96)),
      chartSize.height - (isSmall ? 88 : 92),
    );

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        child: Container(
          width: cardWidth,
          padding: EdgeInsets.fromLTRB(
            isSmall ? 8 : 10,
            isSmall ? 8 : 10,
            isSmall ? 8 : 10,
            isSmall ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3A3A).withOpacity(0.96),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: isSmall ? 10 : 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label (${_namaUnsur(label)})',
                  style: TextStyle(
                    fontSize: isSmall ? 12 : 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 10, color: Color(0xFF39B54A)),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Hasil: ${hasil.toStringAsFixed(2)}')),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 10, color: Color(0xFFE39A25)),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Standar: ${standar.toStringAsFixed(2)}')),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Selisih: ${diff.toStringAsFixed(2)} ($status)',
                  style: TextStyle(
                    fontSize: isSmall ? 11 : 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _namaUnsur(String label) {
    switch (label) {
      case 'N':
        return 'Nitrogen';
      case 'P':
        return 'Fosfor';
      case 'K':
        return 'Kalium';
      case 'Mg':
        return 'Magnesium';
      default:
        return label;
    }
  }
}

class _AnalisisChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> hasil;
  final List<double> standar;
  final double maxY;

  const _AnalisisChartPainter({
    required this.labels,
    required this.hasil,
    required this.standar,
    required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 36.0;
    const rightPad = 14.0;
    const topPad = 16.0;
    const bottomPad = 42.0;

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

    final barPaint = Paint()..color = const Color(0xFFBFECEF);
    final linePaint = Paint()
      ..color = const Color(0xFFC68A1E)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    const axisStyle = TextStyle(
      fontSize: 10,
      color: Color(0xFF666666),
    );

    const labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF666666),
    );

    final xStep = chartWidth / labels.length;
    final barWidth = xStep * 0.54;
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

      final labelPainter = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(centerX - labelPainter.width / 2, topPad + chartHeight + 8),
      );
    }

    canvas.drawPath(linePath, linePaint);

    const yLabels = ['3.0', '2.0', '1.0', '0.0'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = topPad + (chartHeight / 3) * i;
      final tp = TextPainter(
        text: TextSpan(text: yLabels[i], style: axisStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    final legendDotPaint = Paint()..color = const Color(0xFF7FB6D8);
    final legendY = size.height - 14.0;

    canvas.drawCircle(Offset(leftPad + 74, legendY), 7, legendDotPaint);

    final hasilLegendPainter = TextPainter(
      text: const TextSpan(
        text: 'Hasil',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF444444),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    hasilLegendPainter.paint(canvas, Offset(leftPad + 86, legendY - 8));

    final dividerPainter = TextPainter(
      text: const TextSpan(
        text: '|',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF444444),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    dividerPainter.paint(canvas, Offset(leftPad + 128, legendY - 8));

    final lineLegendPaint = Paint()
      ..color = const Color(0xFFC68A1E)
      ..strokeWidth = 2.2;

    canvas.drawLine(
      Offset(leftPad + 145, legendY),
      Offset(leftPad + 161, legendY),
      lineLegendPaint,
    );

    final standarLegendPainter = TextPainter(
      text: const TextSpan(
        text: 'Standar',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF444444),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    standarLegendPainter.paint(canvas, Offset(leftPad + 167, legendY - 8));
  }

  @override
  bool shouldRepaint(covariant _AnalisisChartPainter oldDelegate) {
    return oldDelegate.hasil != hasil || oldDelegate.standar != standar;
  }
}