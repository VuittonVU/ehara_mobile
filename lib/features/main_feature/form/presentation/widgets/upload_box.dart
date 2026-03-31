import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;

  const UploadBox({
    super.key,
    this.onTap,
    this.title = 'Unggah File',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 155,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF9A9A9A),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8B8B8B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}