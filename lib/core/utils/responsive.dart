import 'dart:math' as math;
import 'package:flutter/material.dart';

class Responsive {
  const Responsive._();

  static double scale(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortest = math.min(size.width, size.height);

    if (shortest <= 320) return 0.82;
    if (shortest <= 360) return 0.90;
    if (shortest <= 390) return 0.96;
    if (shortest <= 430) return 1.00;
    if (shortest <= 480) return 1.05;
    if (shortest <= 600) return 1.12;
    return 1.20;
  }

  static double w(BuildContext context, double value) => value * scale(context);
  static double h(BuildContext context, double value) => value * scale(context);
  static double sp(BuildContext context, double value) => value * scale(context);
  static double r(BuildContext context, double value) => value * scale(context);

  static bool isCompact(BuildContext context) {
    return MediaQuery.of(context).size.width < 380;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }
}