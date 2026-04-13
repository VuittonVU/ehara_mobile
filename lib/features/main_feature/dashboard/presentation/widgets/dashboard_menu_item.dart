import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../models/dashboard_menu_model.dart';

class DashboardMenuItem extends StatefulWidget {
  final DashboardMenuModel menu;

  const DashboardMenuItem({
    super.key,
    required this.menu,
  });

  @override
  State<DashboardMenuItem> createState() => _DashboardMenuItemState();
}

class _DashboardMenuItemState extends State<DashboardMenuItem> {
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
      scale: _isPressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isPressed ? 1.5 : -2, 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.menu.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            borderRadius: BorderRadius.circular(28),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.textPrimary.withValues(alpha: 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _isPressed ? 0.05 : 0.10,
                    ),
                    blurRadius: _isPressed ? 8 : 14,
                    offset: Offset(0, _isPressed ? 3 : 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final iconBoxSize =
                  (constraints.maxWidth * 0.50).clamp(68.0, 82.0);
                  final iconSize =
                  (iconBoxSize * 0.58).clamp(38.0, 48.0);

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD2E7BA),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: iconSize,
                              height: iconSize,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.asset(
                                  widget.menu.iconPath,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.menu.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium(
                            color: AppColors.primary,
                          ).copyWith(
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}