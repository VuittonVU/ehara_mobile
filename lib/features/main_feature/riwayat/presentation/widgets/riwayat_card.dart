import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/responsive.dart';
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
    final isCompact = Responsive.isCompact(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
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
              Responsive.w(context, 18),
              Responsive.h(context, 12),
              Responsive.w(context, 18),
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
              riwayat.projectName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Responsive.sp(context, isCompact ? 15.5 : 18),
                fontWeight: FontWeight.w800,
                color: const Color(0xFF303030),
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Responsive.w(context, 16),
              Responsive.h(context, 14),
              Responsive.w(context, 16),
              Responsive.h(context, 18),
            ),
            child: Column(
              children: [
                _InfoRow(
                  iconPath: calendarIconPath,
                  leftText: dateText,
                ),
                SizedBox(height: Responsive.h(context, 12)),
                _InfoRow(
                  iconPath: kebunIconPath,
                  leftText: 'Kebun',
                  rightText: riwayat.farmName,
                ),
                SizedBox(height: Responsive.h(context, 18)),
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(context, isCompact ? 42 : 44),
                  child: ElevatedButton(
                    onPressed: onTapDetail,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF4A8A76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.r(context, 10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w(context, 10),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Lihat Hasil Analisis',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, isCompact ? 12 : 14),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
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
    final isCompact = Responsive.isCompact(context);

    final textStyle = TextStyle(
      fontSize: Responsive.sp(context, isCompact ? 12.5 : 14),
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
            width: Responsive.w(context, isCompact ? 18 : 20),
            height: Responsive.w(context, isCompact ? 18 : 20),
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
                  textAlign: TextAlign.right,
                  style: textStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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