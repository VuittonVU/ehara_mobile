import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? subtitle;
  final VoidCallback? onClear;

  const UploadBox({
    super.key,
    this.onTap,
    this.title = 'Choose File',
    this.subtitle,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = title.trim().isNotEmpty && title != 'Choose File';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFDADADA)),
              ),
              child: const Text(
                'Choose File',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344054),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasFile ? title : (subtitle ?? 'No file chosen'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: hasFile
                      ? const Color(0xFF2F7D69)
                      : const Color(0xFF667085),
                ),
              ),
            ),
            if (onClear != null && hasFile) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
