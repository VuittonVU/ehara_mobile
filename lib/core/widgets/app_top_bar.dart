import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onActionTap;
  final String? backIconPath;
  final String? actionIconPath;
  final bool centerTitle;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;

  const AppTopBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.onActionTap,
    this.backIconPath,
    this.actionIconPath,
    this.centerTitle = true,
    this.height = 72,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = Colors.transparent,
    this.borderColor = const Color(0xFF8D8D8D),
    this.titleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _TopBarIconButton(
            onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
            iconPath: backIconPath,
          ),
          Expanded(
            child: centerTitle
                ? Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
            )
                : Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
          ),
          _TopBarIconButton(
            onTap: onActionTap,
            iconPath: actionIconPath,
          ),
        ],
      ),
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? iconPath;

  const _TopBarIconButton({
    required this.onTap,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: iconPath == null
              ? const SizedBox.shrink()
              : Image.asset(
            iconPath!,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}