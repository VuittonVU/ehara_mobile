import 'dart:typed_data';

import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? subtitle;
  final Uint8List? imageBytes;
  final VoidCallback? onClear;

  const UploadBox({
    super.key,
    this.onTap,
    this.title = 'Unggah File',
    this.subtitle,
    this.imageBytes,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBytes != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 155),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF9A9A9A),
            style: BorderStyle.solid,
          ),
        ),
        child: hasImage
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                imageBytes!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A4A4A),
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (onClear != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onClear,
                  child: const Text('Hapus'),
                ),
              ),
            ],
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              size: 64,
              color: Color(0xFF9D9D9D),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8B8B8B),
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}