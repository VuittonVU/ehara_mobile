import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive.dart';
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
        borderRadius: BorderRadius.circular(
          Responsive.r(context, 24),
        ),
        border: Border.all(
          color: const Color(0xFF3E806D),
          width: Responsive.w(context, 2.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: Responsive.w(context, 10),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              Responsive.w(context, 20),
              Responsive.h(context, 12),
              Responsive.w(context, 20),
              Responsive.h(context, 10),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF3E806D),
                  width: Responsive.w(context, 2),
                ),
              ),
            ),
            child: Text(
              item.namaProjek,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.w800,
                color: const Color(0xFF303030),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.w(context, 18),
              Responsive.h(context, 14),
              Responsive.w(context, 18),
              Responsive.h(context, 18),
            ),
            child: Column(
              children: [
                _InfoRow(
                  iconPath: calendarIconPath,
                  leftText: tanggalText,
                ),
                SizedBox(height: Responsive.h(context, 10)),
                _InfoRow(
                  iconPath: kebunIconPath,
                  leftText: 'Kebun',
                  rightText: item.kebun,
                ),
                SizedBox(height: Responsive.h(context, 10)),
                _InfoRow(
                  iconPath: statusIconPath,
                  leftText: 'Status Pembayaran',
                  rightText: _statusText(item.status),
                  rightTextColor: statusColor,
                ),
                SizedBox(height: Responsive.h(context, 18)),
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(context, 44),
                  child: ElevatedButton(
                    onPressed: onPrimaryTap,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF4A8A76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.r(context, 10),
                        ),
                      ),
                    ),
                    child: Text(
                      _buttonText(item.status),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
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
    final textStyle = TextStyle(
      fontSize: Responsive.sp(context, 14),
      fontWeight: FontWeight.w600,
      color: const Color(0xFF373737),
      height: 1.25,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: Responsive.h(context, 1)),
          child: Image.asset(
            iconPath,
            width: Responsive.w(context, 20),
            height: Responsive.w(context, 20),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: Responsive.w(context, 10)),
        Expanded(
          child: hasRightText
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  leftText,
                  style: textStyle,
                ),
              ),
              SizedBox(width: Responsive.w(context, 8)),
              Text(
                ':',
                style: textStyle.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(width: Responsive.w(context, 8)),
              Expanded(
                child: Text(
                  rightText!,
                  style: textStyle.copyWith(
                    color: rightTextColor ?? const Color(0xFF373737),
                  ),
                ),
              ),
            ],
          )
              : Text(
            leftText,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}