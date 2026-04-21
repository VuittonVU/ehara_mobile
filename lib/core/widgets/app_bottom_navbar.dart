import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive.dart';

class AppBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;
    final isCompact = Responsive.isCompact(context);

    final fabSize = Responsive.w(context, isCompact ? 60 : 66);
    final fabOverlap = Responsive.h(context, isCompact ? 24 : 28);
    final navBarHeight = Responsive.h(context, isCompact ? 78 : 84);
    final totalHeight = navBarHeight + fabOverlap + bottomInset;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: navBarHeight + bottomInset,
              padding: EdgeInsets.fromLTRB(
                Responsive.w(context, 8),
                Responsive.h(context, 5),
                Responsive.w(context, 8),
                bottomInset > 0
                    ? bottomInset + Responsive.h(context, 4)
                    : Responsive.h(context, 8),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Responsive.r(context, 24)),
                  topRight: Radius.circular(Responsive.r(context, 24)),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.textPrimary.withValues(alpha: 0.10),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: Responsive.w(context, 14),
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _BottomNavItem(
                      iconPath: 'assets/icons/house.png',
                      label: 'Dashboard',
                      isActive: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavItem(
                      iconPath: 'assets/icons/riwayat.png',
                      label: 'Riwayat',
                      isActive: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),
                  SizedBox(width: fabSize + Responsive.w(context, 30)),
                  Expanded(
                    child: _BottomNavItem(
                      iconPath: 'assets/icons/cart.png',
                      label: 'Pembayaran',
                      isActive: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavItem(
                      iconPath: 'assets/icons/circle_user.png',
                      label: 'Profil',
                      isActive: currentIndex == 4,
                      onTap: () => onTap(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _CenterNavButton(
              isActive: currentIndex == 2,
              size: fabSize,
              onTap: () => onTap(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatefulWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemColor =
    widget.isActive ? const Color(0xFF387867) : AppColors.textPrimary;

    final isCompact = Responsive.isCompact(context);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 110),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          borderRadius: BorderRadius.circular(Responsive.r(context, 14)),
          child: SizedBox(
            height: Responsive.h(context, 54),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.iconPath,
                  width: Responsive.w(context, 20),
                  height: Responsive.w(context, 20),
                  color: itemColor,
                ),
                SizedBox(height: Responsive.h(context, 4)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: AppTextStyles.caption(
                      color: itemColor,
                    ).copyWith(
                      fontSize: Responsive.sp(
                        context,
                        isCompact ? 8.1 : 8.8,
                      ),
                      height: 1.1,
                      fontWeight:
                      widget.isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CenterNavButton extends StatefulWidget {
  final bool isActive;
  final double size;
  final VoidCallback onTap;

  const _CenterNavButton({
    required this.isActive,
    required this.size,
    required this.onTap,
  });

  @override
  State<_CenterNavButton> createState() => _CenterNavButtonState();
}

class _CenterNavButtonState extends State<_CenterNavButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isActive
        ? const Color(0xFF387867)
        : AppColors.textPrimary.withValues(alpha: 0.75);
    final isCompact = Responsive.isCompact(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTap();
        },
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: widget.size + Responsive.w(context, 38),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF387867),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: Responsive.w(context, 8),
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/palm.png',
                      width: widget.size * 0.32,
                      height: widget.size * 0.32,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(context, 4)),
                Text(
                  'Tambah\nAnalisis',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: AppTextStyles.caption(
                    color: textColor,
                  ).copyWith(
                    fontSize: Responsive.sp(
                      context,
                      isCompact ? 7.8 : 8.6,
                    ),
                    height: 1.05,
                    fontWeight:
                    widget.isActive ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}