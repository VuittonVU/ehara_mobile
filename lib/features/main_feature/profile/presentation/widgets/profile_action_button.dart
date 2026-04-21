import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/pressable_button.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback? onTap;

  const ProfileActionButton({
    super.key,
    required this.label,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = Responsive.w(context, 22);

    return PressableButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        Responsive.r(context, 20),
      ),
      color: const Color(0xFFE95B59),
      border: Border.all(
        color: const Color(0xFFE95B59),
        width: 1.4,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 18),
          vertical: Responsive.h(context, 16),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              color: Colors.white,
            ),
            SizedBox(width: Responsive.w(context, 14)),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.sp(context, 16),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}