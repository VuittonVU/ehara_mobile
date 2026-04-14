import 'package:flutter/material.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String iconPath;

  const DateInputField({
    super.key,
    required this.label,
    required this.onTap,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: const Color(0xFFB2B2B2),
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: label.contains('-')
                      ? const Color(0xFF3D3D3D)
                      : const Color(0xFF8C8C8C),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              iconPath,
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}