import 'dart:math' as math;
import 'package:flutter/material.dart';

class GanodermaInteractiveMap extends StatefulWidget {
  final bool showLegend;
  final bool showControls;

  const GanodermaInteractiveMap({
    super.key,
    this.showLegend = true,
    this.showControls = true,
  });

  @override
  State<GanodermaInteractiveMap> createState() => _GanodermaInteractiveMapState();
}

class _GanodermaInteractiveMapState extends State<GanodermaInteractiveMap> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  double _baseScale = 1.0;

  void _zoomIn() {
    setState(() {
      _scale = (_scale + 0.2).clamp(1.0, 4.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale - 0.2).clamp(1.0, 4.0);
      if (_scale == 1.0) {
        _offset = Offset.zero;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: (_) {
          _baseScale = _scale;
        },
        onScaleUpdate: (details) {
          setState(() {
            _scale = (_baseScale * details.scale).clamp(1.0, 4.0);
            if (details.pointerCount == 1) {
              _offset += details.focalPointDelta;
            }
          });
        },
        onDoubleTap: () {
          setState(() {
            _scale = 1.0;
            _offset = Offset.zero;
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xFFF0ECE6),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(_offset.dx, _offset.dy)
                    ..scale(_scale),
                  child: CustomPaint(
                    painter: _GanodermaMapPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            if (widget.showControls)
              Positioned(
                left: 12,
                top: 12,
                child: Column(
                  children: [
                    _MapControlButton(
                      icon: Icons.add,
                      onTap: _zoomIn,
                    ),
                    const SizedBox(height: 8),
                    _MapControlButton(
                      icon: Icons.remove,
                      onTap: _zoomOut,
                    ),
                  ],
                ),
              ),
            if (widget.showLegend)
              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  width: 154,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keterangan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334A6E),
                        ),
                      ),
                      SizedBox(height: 8),
                      _LegendRow(
                        color: Color(0xFFE60012),
                        label: 'Ganoderma Terdeteksi',
                      ),
                      SizedBox(height: 6),
                      _LegendRow(
                        color: Color(0xFF11D91B),
                        label: 'Tidak Terdeteksi',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: const Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF223355),
            ),
          ),
        ),
      ],
    );
  }
}

class _GanodermaMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFF29E84)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final outlinePaint = Paint()
      ..color = const Color(0xFFD4705F)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final whiteRoadPaint = Paint()
      ..color = const Color(0xFFFDFDFD)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final labelStyle = const TextStyle(
      fontSize: 11,
      color: Color(0xFF6D554A),
      fontWeight: FontWeight.w600,
    );

    final mainRoad = Path()
      ..moveTo(36, size.height)
      ..quadraticBezierTo(76, size.height - 100, 86, size.height - 220)
      ..quadraticBezierTo(96, size.height - 300, 106, 0);

    canvas.drawPath(mainRoad, roadPaint);
    canvas.drawPath(mainRoad, outlinePaint);

    final minorRoad = Path()
      ..moveTo(140, 120)
      ..lineTo(180, 120)
      ..lineTo(220, 100)
      ..lineTo(236, 56);

    canvas.drawPath(minorRoad, whiteRoadPaint);

    final tp = TextPainter(
      text: TextSpan(text: 'Jl. Brigjend Katamso', style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(78, 210);
    canvas.rotate(-1.55);
    tp.paint(canvas, Offset.zero);
    canvas.restore();

    final random = math.Random(7);

    for (int i = 0; i < 22; i++) {
      final dx = 135 + random.nextDouble() * 36;
      final dy = size.height - 94 + random.nextDouble() * 18;
      canvas.drawCircle(
        Offset(dx, dy),
        5,
        Paint()..color = const Color(0xFFE60012),
      );
    }

    for (int i = 0; i < 32; i++) {
      final dx = 176 + random.nextDouble() * 48;
      final dy = size.height - 120 + random.nextDouble() * 32;
      canvas.drawCircle(
        Offset(dx, dy),
        4,
        Paint()..color = const Color(0xFF11D91B),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}