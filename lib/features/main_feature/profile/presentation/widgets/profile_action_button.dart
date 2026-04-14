import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../../core/widgets/pressable_button.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback? onTap;

  const ProfileActionButton({
    super.key,
    required this.label,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfileBaseTile(
      backgroundColor: const Color(0xFFFF4B4B),
      borderColor: const Color(0xFFFF4B4B),
      foregroundColor: Colors.white,
      iconPath: iconPath,
      label: label,
      onTap: onTap,
    );
  }
}

class _ProfileBaseTile extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const _ProfileBaseTile({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 18;
    const double verticalPadding = 16;
    const double iconSize = 26;
    const double fontSize = 16;
    const double textHeight = 1.2;

    final textScaler = MediaQuery.textScalerOf(context);
    final scaledLineHeight = textScaler.scale(fontSize * textHeight);
    final minTileHeight =
        math.max(iconSize, scaledLineHeight) + (verticalPadding * 2);

    return PressableButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      color: backgroundColor,
      border: Border.all(
        color: borderColor,
        width: 1.6,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minTileHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            children: [
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: Center(
                  child: Image.asset(
                    iconPath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                    color: foregroundColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    height: textHeight,
                    letterSpacing: 0.2,
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