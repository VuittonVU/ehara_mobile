import 'package:flutter/material.dart';

class RiwayatCertificateStatus extends StatelessWidget {
  final bool isTerbit;
  final String label;

  const RiwayatCertificateStatus({
    super.key,
    required this.isTerbit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: isTerbit ? const Color(0xFF2E8B57) : const Color(0xFFFF3B30),
      ),
    );
  }
}