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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 190,
                  height: 190,
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
                    right: 18,
                    bottom: 18,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.access_time,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.35,
                color: Color(0xFF3E3E3E),
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