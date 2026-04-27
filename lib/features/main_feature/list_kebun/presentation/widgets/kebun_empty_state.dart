import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive.dart';

class KebunEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final bool showClockBadge;
  final String? imagePath;

  const KebunEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.showClockBadge = false,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = Responsive.w(context, 190);
    final badgeSize = Responsive.w(context, 42);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔥 ROBOT + BADGE
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: imagePath != null
                      ? Image.asset(
                    imagePath!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const _KebunRobotFallback();
                    },
                  )
                      : const _KebunRobotFallback(),
                ),

                if (showClockBadge)
                  Positioned(
                    right: Responsive.w(context, 18),
                    bottom: Responsive.w(context, 18),
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: Responsive.w(context, 2),
                        ),
                      ),
                      child: Icon(
                        Icons.access_time,
                        size: Responsive.w(context, 24),
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: Responsive.h(context, 20)),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.w800,
                color: const Color(0xFF333333),
              ),
            ),

            SizedBox(height: Responsive.h(context, 8)),

            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.sp(context, 14),
                height: 1.35,
                color: const Color(0xFF3E3E3E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KebunRobotFallback extends StatelessWidget {
  const _KebunRobotFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.w(context, 170),
      height: Responsive.w(context, 170),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF86E16B).withOpacity(0.95),
            const Color(0xFF2F8C4C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F8C4C).withOpacity(0.25),
            blurRadius: Responsive.w(context, 16),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.smart_toy_outlined,
          size: Responsive.w(context, 88),
          color: Colors.white,
        ),
      ),
    );
  }
}