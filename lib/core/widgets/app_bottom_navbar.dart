import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

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
    return SizedBox(
      height: 110,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 98,
              padding: const EdgeInsets.only(top: 6, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: AppColors.textPrimary.withOpacity(0.15),
                  ),
                ),
              ),
              child: Row(
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
                  const SizedBox(width: 96),
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
                      label: 'Profile',
                      isActive: currentIndex == 4,
                      onTap: () => onTap(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            child: _CenterNavFullButton(
              isActive: currentIndex == 2,
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
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  widget.iconPath,
                  width: 22,
                  height: 22,
                  color: itemColor,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption(
                    color: itemColor,
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

class _CenterNavFullButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CenterNavFullButton({
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_CenterNavFullButton> createState() => _CenterNavFullButtonState();
}

class _CenterNavFullButtonState extends State<_CenterNavFullButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
    widget.isActive ? const Color(0xFF387867) : AppColors.textPrimary;

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
        borderRadius: BorderRadius.circular(32),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: 108,
            height: 108,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A008),
                    shape: BoxShape.circle,
                    border: widget.isActive
                        ? Border.all(
                      color: const Color(0xFFBFD8D0),
                      width: 3,
                    )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/palm.png',
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tambah\nAnalisis',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption(
                    color: textColor,
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