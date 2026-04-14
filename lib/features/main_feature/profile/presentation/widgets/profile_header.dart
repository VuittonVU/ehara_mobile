import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final String? backIconPath;
  final bool centerTitle;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color titleColor;

  const ProfileHeader({
    super.key,
    required this.title,
    this.onBackTap,
    this.backIconPath = 'assets/icons/arrow_back.png',
    this.centerTitle = true,
    this.height = 72,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = Colors.transparent,
    this.titleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      color: backgroundColor, // ✅ no border / no divider
      child: Row(
        children: [
          // 🔙 Back Button (no shadow, clean)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: backIconPath == null
                      ? const SizedBox.shrink()
                      : Image.asset(
                    backIconPath!,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // 📝 Title (same style as AppTopBar)
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

          const SizedBox(width: 40),
        ],
      ),
    );
  }
}