import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onActionTap;
  final String? backIconPath;
  final String? actionIconPath;
  final bool showBackButton;
  final bool showBottomDivider;

  const AppTopBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.onActionTap,
    this.backIconPath,
    this.actionIconPath,
    this.showBackButton = true,
    this.showBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Row(
              children: [
                if (showBackButton)
                  GestureDetector(
                    onTap: onBackTap,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: backIconPath != null
                            ? Image.asset(
                          backIconPath!,
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                        )
                            : const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 8),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: showBackButton ? 10 : 4),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ),
                ),

                if (actionIconPath != null)
                  GestureDetector(
                    onTap: onActionTap,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: Image.asset(
                          actionIconPath!,
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 44),
              ],
            ),
          ),

          if (showBottomDivider)
            const SizedBox(
              width: double.infinity,
              child: Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE0E0E0),
              ),
            ),
        ],
      ),
    );
  }
}