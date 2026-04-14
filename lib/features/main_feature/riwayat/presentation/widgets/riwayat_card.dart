import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/riwayat_model.dart';

class RiwayatCard extends StatelessWidget {
  final RiwayatModel riwayat;
  final VoidCallback onTapDetail;
  final String calendarIconPath;
  final String kebunIconPath;

  const RiwayatCard({
    super.key,
    required this.riwayat,
    required this.onTapDetail,
    required this.calendarIconPath,
    required this.kebunIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('dd-MM-yyyy').format(riwayat.date);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3E806D),
          width: 2.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF3E806D),
                  width: 2.2,
                ),
              ),
            ),
            child: Text(
              riwayat.projectName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF303030),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              children: [
                _InfoRow(
                  iconPath: calendarIconPath,
                  leftText: dateText,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  iconPath: kebunIconPath,
                  leftText: 'Kebun',
                  rightText: riwayat.farmName,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 242,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onTapDetail,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF4A8A76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Hasil Analisis',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String leftText;
  final String? rightText;

  const _InfoRow({
    required this.iconPath,
    required this.leftText,
    this.rightText,
  });

  @override
  Widget build(BuildContext context) {
    final hasRightText = rightText != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Image.asset(
            iconPath,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: hasRightText
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  leftText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF373737),
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                ':',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF373737),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rightText!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF373737),
                    height: 1.25,
                  ),
                ),
              ),
            ],
          )
              : Text(
            leftText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF373737),
            ),
          ),
        ),
      ],
    );
  }
}