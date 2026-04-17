import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../shared/widgets/analysis_top_bar.dart';

class EHaraFullMapPage extends StatelessWidget {
  const EHaraFullMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AnalysisTopBar(
                title: 'Peta Sebaran Hara',
                onBackTap: () => context.pop(),
                onPdfTap: () {},
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _FullMapCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullMapCard extends StatelessWidget {
  const _FullMapCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFC9C9C9),
          width: 1.4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Text(
              'Prototype Sebaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF373737),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 1.1,
            color: const Color(0xFFC9C9C9),
          ),
          const SizedBox(height: 18),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: _PrototypeMap(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrototypeMap extends StatefulWidget {
  const _PrototypeMap();

  @override
  State<_PrototypeMap> createState() => _PrototypeMapState();
}

class _PrototypeMapState extends State<_PrototypeMap> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: Colors.white,
        child: GestureDetector(
          onScaleUpdate: (details) {
            setState(() {
              _scale = details.scale.clamp(1.0, 4.0);
              _offset += details.focalPointDelta;
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
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(_offset.dx, _offset.dy)
                    ..scale(_scale),
                  child: CustomPaint(
                    painter: _PrototypeMapPainter(),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                top: 14,
                child: Column(
                  children: [
                    _ZoomButton(
                      icon: Icons.add,
                      onTap: () {
                        setState(() {
                          _scale = (_scale + 0.2).clamp(1.0, 4.0);
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    _ZoomButton(
                      icon: Icons.remove,
                      onTap: () {
                        setState(() {
                          _scale = (_scale - 0.2).clamp(1.0, 4.0);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  width: 170,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                        color: Color(0xFF2F7CC9),
                        label: 'Sebaran Titik',
                      ),
                      SizedBox(height: 6),
                      _LegendRow(
                        color: Color(0xFF387867),
                        label: 'Area Fokus',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Double tap untuk reset',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({
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

class _PrototypeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF5F2EB);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFE0DDD5)
      ..strokeWidth = 1.2;

    for (double x = 20; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 20; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final borderPaint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(Offset.zero & size, borderPaint);

    final focusPaint = Paint()
      ..color = const Color(0x22387867)
      ..style = PaintingStyle.fill;

    final focusPath = Path()
      ..moveTo(size.width * 0.18, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.65,
        size.width * 0.62,
        size.height * 0.52,
      )
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height * 0.45,
        size.width * 0.82,
        size.height * 0.26,
      )
      ..lineTo(size.width * 0.86, size.height * 0.18)
      ..lineTo(size.width * 0.70, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.24,
        size.width * 0.24,
        size.height * 0.48,
      )
      ..close();

    canvas.drawPath(focusPath, focusPaint);

    final roadPaint = Paint()
      ..color = const Color(0xFFD2CDC2)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final roadPath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.90)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.72,
        size.width * 0.26,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.36,
        size.width * 0.18,
        size.height * 0.10,
      );

    canvas.drawPath(roadPath, roadPaint);

    final pointPaint = Paint()
      ..color = const Color(0xFF2F7CC9)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final random = Random(42);
    final points = <Offset>[];

    for (int i = 0; i < 260; i++) {
      final dx = 40 + random.nextDouble() * (size.width - 80);
      final dy = 30 + random.nextDouble() * (size.height - 60);

      final normalizedX = dx / size.width;
      final normalizedY = dy / size.height;

      final insideShape = normalizedX > 0.14 &&
          normalizedX < 0.88 &&
          normalizedY > 0.14 &&
          normalizedY < 0.88 &&
          normalizedY > (0.98 - normalizedX * 0.9);

      if (insideShape) {
        points.add(Offset(dx, dy));
      }
    }

    canvas.drawPoints(PointMode.points, points, pointPaint);

    final titlePainter = TextPainter(
      text: const TextSpan(
        text: 'Sebaran',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    titlePainter.paint(
      canvas,
      Offset(size.width / 2 - titlePainter.width / 2, 6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}