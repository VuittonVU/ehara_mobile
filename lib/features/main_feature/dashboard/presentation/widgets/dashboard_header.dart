import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo/logo_ehara.png',
          width: 72,
          height: 72,
          fit: BoxFit.contain,
        ),
        _AnimatedPressButton(
          onTap: onNotificationTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.85),
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.75),
                width: 1,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/bell.png',
                width: 26,
                height: 26,
                fit: BoxFit.contain,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedPressButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  const _AnimatedPressButton({
    required this.child,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  State<_AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<_AnimatedPressButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isPressed ? 1.5 : -1.5, 0),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isPressed ? 0.05 : 0.10),
              blurRadius: _isPressed ? 8 : 14,
              offset: Offset(0, _isPressed ? 3 : 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            borderRadius: widget.borderRadius,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}