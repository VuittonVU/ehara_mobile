import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/pressable_button.dart';

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
      backgroundColor: const Color(0xFFFFFFFF),
      borderColor: const Color(0xFFC9C9C9),
      foregroundColor: const Color(0xFF3E3E3E),
      iconPath: iconPath,
      label: title,
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: Responsive.w(context, 30),
        color: const Color(0xFF4E4E4E),
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
    final horizontalPadding = Responsive.w(context, 18);
    final verticalPadding = Responsive.h(context, 16);
    final iconSize = Responsive.w(context, 24);
    final fontSize = Responsive.sp(context, 16);
    const textHeight = 1.2;

    final textScaler = MediaQuery.textScalerOf(context);
    final scaledLineHeight = textScaler.scale(fontSize * textHeight);
    final minTileHeight =
        math.max(iconSize, scaledLineHeight) + (verticalPadding * 2);

    return PressableButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        Responsive.r(context, 20),
      ),
      color: backgroundColor,
      border: Border.all(
        color: borderColor,
        width: 1.6,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minTileHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(
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
              SizedBox(width: Responsive.w(context, 16)),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}