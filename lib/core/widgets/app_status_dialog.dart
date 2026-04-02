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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
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
              height: 170,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B6B6B),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
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