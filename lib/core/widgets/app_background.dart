import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// FULL BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            'assets/background/bg.png',
            fit: BoxFit.cover,
          ),
        ),

        /// MAIN CONTENT
        child,
      ],
    );
  }
}