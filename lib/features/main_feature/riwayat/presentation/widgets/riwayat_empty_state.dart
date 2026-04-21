import 'package:flutter/material.dart';

class RiwayatEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final bool showClockBadge;
  final String? imagePath;

  const RiwayatEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.showClockBadge = false,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: isSmall ? 160 : 190,
                  height: isSmall ? 160 : 190,
                  child: imagePath != null
                      ? Image.asset(
                    imagePath!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const _RobotFallback();
                    },
                  )
                      : const _RobotFallback(),
                ),
                if (showClockBadge)
                  Positioned(
                    right: isSmall ? 12 : 18,
                    bottom: isSmall ? 12 : 18,
                    child: Container(
                      width: isSmall ? 36 : 42,
                      height: isSmall ? 36 : 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.access_time,
                        size: isSmall ? 20 : 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isSmall ? 16 : 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 16 : 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 13 : 14,
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

class _RobotFallback extends StatelessWidget {
  const _RobotFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 170,
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
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.smart_toy_outlined,
          size: 88,
          color: Colors.white,
        ),
      ),
    );
  }
}