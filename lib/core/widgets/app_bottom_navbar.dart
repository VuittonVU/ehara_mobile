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
    return Container(
      height: 98,
      padding: const EdgeInsets.only(top: 4, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.textPrimary.withOpacity(0.15),
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Row(
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
              const SizedBox(width: 82),
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
          Positioned(
            top: -34,
            child: _CenterNavButton(
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ),
          Positioned(
            bottom: 12,
            child: IgnorePointer(
              child: Text(
                'Tambah\nAnalisis',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(
                  color: currentIndex == 2
                      ? const Color(0xFF387867)
                      : AppColors.textPrimary,
                ),
              ),
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

class _CenterNavButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CenterNavButton({
    required this.isActive,
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
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
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
      ),
    );
  }
}