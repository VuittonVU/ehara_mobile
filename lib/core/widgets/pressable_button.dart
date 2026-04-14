import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Color? color;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final bool enableHaptic;
  final double pressedScale;
  final double pressedTranslateY;
  final double idleTranslateY;

  const PressableButton({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.color,
    this.border,
    this.padding,
    this.enableHaptic = true,
    this.pressedScale = 0.97,
    this.pressedTranslateY = 2,
    this.idleTranslateY = -1.5,
  });

  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
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
      scale: _isPressed ? widget.pressedScale : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _isPressed ? widget.pressedTranslateY : widget.idleTranslateY,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isPressed ? 0.03 : 0.06),
              blurRadius: _isPressed ? 3 : 6,
              offset: Offset(0, _isPressed ? 1.5 : 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: Material(
            color: widget.color ?? Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) {
                if (widget.enableHaptic) {
                  HapticFeedback.lightImpact();
                }
                _setPressed(true);
              },
              onTapUp: (_) => _setPressed(false),
              onTapCancel: () => _setPressed(false),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: widget.borderRadius,
                  border: widget.border,
                ),
                child: widget.padding != null
                    ? Padding(
                  padding: widget.padding!,
                  child: widget.child,
                )
                    : widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}