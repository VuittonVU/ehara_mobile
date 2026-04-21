import 'package:flutter/material.dart';

class AppStatusDialog extends StatelessWidget {
  final String title;
  final String message;
  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  final Color borderColor;
  final Color buttonColor;
  final Color textColor;

  const AppStatusDialog({
    super.key,
    required this.title,
    required this.message,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
    this.borderColor = const Color(0xFF3E7F69),
    this.buttonColor = const Color(0xFF4A8A74),
    this.textColor = const Color(0xFF4A4A4A),
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String imagePath,
    required String buttonText,
    required VoidCallback onPressed,
    Color borderColor = const Color(0xFF3E7F69),
    Color buttonColor = const Color(0xFF4A8A74),
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.18),
      builder: (_) {
        return AppStatusDialog(
          title: title,
          message: message,
          imagePath: imagePath,
          buttonText: buttonText,
          onPressed: onPressed,
          borderColor: borderColor,
          buttonColor: buttonColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    final horizontalPadding = isSmallScreen ? 18.0 : 24.0;
    final dialogRadius = isSmallScreen ? 20.0 : 22.0;
    final imageHeight = isSmallScreen ? 145.0 : 170.0;
    final titleFontSize = isSmallScreen ? 16.0 : 18.0;
    final messageFontSize = isSmallScreen ? 12.5 : 13.0;
    final buttonFontSize = isSmallScreen ? 12.0 : 13.0;
    final buttonHeight = isSmallScreen ? 50.0 : 54.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 20 : 28,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          isSmallScreen ? 22 : 28,
          horizontalPadding,
          isSmallScreen ? 24 : 30,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dialogRadius),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
            SizedBox(height: isSmallScreen ? 14 : 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: messageFontSize,
                color: const Color(0xFF6B6B6B),
                height: 1.45,
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    buttonText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: buttonFontSize,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}