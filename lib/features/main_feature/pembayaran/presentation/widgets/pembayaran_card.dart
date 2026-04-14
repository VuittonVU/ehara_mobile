import 'package:flutter/material.dart';

import '../../models/pembayaran_model.dart';

class PembayaranCard extends StatelessWidget {
  final PembayaranModel item;
  final String tanggalText;
  final VoidCallback? onPrimaryTap;

  final String calendarIconPath;
  final String kebunIconPath;
  final String statusIconPath;

  const PembayaranCard({
    super.key,
    required this.item,
    required this.tanggalText,
    this.onPrimaryTap,
    required this.calendarIconPath,
    required this.kebunIconPath,
    required this.statusIconPath,
  });

  Color _statusColor(PembayaranStatus status) {
    switch (status) {
      case PembayaranStatus.proses:
        return const Color(0xFFFFA000);
      case PembayaranStatus.selesai:
        return const Color(0xFF2F7D69);
      case PembayaranStatus.dibatalkan:
        return const Color(0xFFFF4D4D);
    }
  }

  String _statusText(PembayaranStatus status) {
    switch (status) {
      case PembayaranStatus.proses:
        return 'Proses Pembayaran';
      case PembayaranStatus.selesai:
        return 'Pembayaran Selesai';
      case PembayaranStatus.dibatalkan:
        return 'Belum Pembayaran';
    }
  }

  String _buttonText(PembayaranStatus status) {
    switch (status) {
      case PembayaranStatus.proses:
      case PembayaranStatus.dibatalkan:
        return 'Menu Pembayaran';
      case PembayaranStatus.selesai:
        return 'Download Invoice';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3E806D),
          width: 2.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
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
              item.namaProjek,
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
                  leftText: tanggalText,
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  iconPath: kebunIconPath,
                  leftText: 'Kebun',
                  rightText: item.kebun,
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  iconPath: statusIconPath,
                  leftText: 'Status Pembayaran',
                  rightText: _statusText(item.status),
                  rightTextColor: statusColor,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 242,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onPrimaryTap,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF4A8A76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _buttonText(item.status),
                      style: const TextStyle(
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
  final Color? rightTextColor;

  const _InfoRow({
    required this.iconPath,
    required this.leftText,
    this.rightText,
    this.rightTextColor,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: rightTextColor ?? const Color(0xFF373737),
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