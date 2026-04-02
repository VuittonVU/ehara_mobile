import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfileBaseTile(
      backgroundColor: const Color(0xFFF7F7F7),
      borderColor: const Color(0xFFC9C9C9),
      foregroundColor: const Color(0xFF3E3E3E),
      iconPath: iconPath,
      label: title,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 32,
        color: Color(0xFF4E4E4E),
      ),
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
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileBaseTile({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.iconPath,
    required this.label,
    this.trailing,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1.6,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
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
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        color: foregroundColor,
                        height: textHeight,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}