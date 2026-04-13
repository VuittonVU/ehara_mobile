import 'package:flutter/material.dart';

import '../../models/pembayaran_model.dart';

class PembayaranCard extends StatelessWidget {
  final PembayaranModel item;
  final String tanggalText;
  final VoidCallback? onPrimaryTap;

  const PembayaranCard({
    super.key,
    required this.item,
    required this.tanggalText,
    this.onPrimaryTap,
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
        return 'Pembayaran Dibatalkan';
    }
  }

  String _buttonText(PembayaranStatus status) {
    switch (status) {
      case PembayaranStatus.proses:
        return 'Menu Pembayaran';
      case PembayaranStatus.selesai:
        return 'Download Invoice';
      case PembayaranStatus.dibatalkan:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);
    final showButton = item.status != PembayaranStatus.dibatalkan;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF3E7F69),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            item.namaProjek,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: Color(0xFF4C4C4C),
              ),
              const SizedBox(width: 10),
              Text(
                tanggalText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4C4C4C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFD2D2D2),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.layers_outlined,
                size: 20,
                color: Color(0xFF4C4C4C),
              ),
              const SizedBox(width: 10),
              Text(
                'Jumlah Baris: ${item.jumlahBaris}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xFF4C4C4C),
              ),
              const SizedBox(width: 10),
              const Text(
                'Status Pembayaran: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  _statusText(item.status),
                  style: TextStyle(
                    fontSize: 14,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (showButton) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: 182,
              height: 42,
              child: ElevatedButton(
                onPressed: onPrimaryTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E7F69),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _buttonText(item.status),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}