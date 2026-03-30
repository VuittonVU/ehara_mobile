import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class DashboardGreetingCard extends StatelessWidget {
  final String userName;

  const DashboardGreetingCard({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomPaint(
            painter: _GreetingBubblePainter(
              borderColor: AppColors.textPrimary.withValues(alpha: 0.18),
              fillColor: Colors.white,
              shadowColor: Colors.black.withValues(alpha: 0.06),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: AppTextStyles.heading3(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: AppTextStyles.heading3(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'di Akses Informasi Status Hara',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 132,
          child: Image.asset(
            'assets/maskot/maskot1.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _GreetingBubblePainter extends CustomPainter {
  final Color borderColor;
  final Color fillColor;
  final Color shadowColor;

  const _GreetingBubblePainter({
    required this.borderColor,
    required this.fillColor,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bubblePath = Path()
      ..moveTo(28, 0)
      ..lineTo(size.width - 28, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 28)
      ..lineTo(size.width, size.height - 36)
      ..lineTo(size.width + 10, size.height - 18)
      ..lineTo(size.width - 18, size.height - 16)
      ..lineTo(28, size.height - 16)
      ..quadraticBezierTo(0, size.height - 16, 0, size.height - 44)
      ..lineTo(0, 28)
      ..quadraticBezierTo(0, 0, 28, 0)
      ..close();

    canvas.drawShadow(
      bubblePath,
      shadowColor,
      8,
      false,
    );

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(bubblePath, fillPaint);
    canvas.drawPath(bubblePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _GreetingBubblePainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}