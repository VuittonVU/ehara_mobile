import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/responsive.dart';
import '../../models/sertifikat_model.dart';

class SertifikatCard extends StatelessWidget {
  final SertifikatModel sertifikat;
  final VoidCallback onDownload;
  final String calendarIconPath;
  final String kebunIconPath;
  final String sertifikatIconPath;

  const SertifikatCard({
    super.key,
    required this.sertifikat,
    required this.onDownload,
    required this.calendarIconPath,
    required this.kebunIconPath,
    required this.sertifikatIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('dd-MM-yyyy').format(sertifikat.date);

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
            color: Colors.black.withOpacity(0.14),
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
              sertifikat.projectName,
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
              Responsive.h(context, 16),
            ),
            child: Column(
              children: [
                _InfoRow(
                  iconPath: calendarIconPath,
                  leftText: dateText,
                ),
                SizedBox(height: Responsive.h(context, 10)),
                _InfoRow(
                  iconPath: kebunIconPath,
                  leftText: 'Kebun',
                  rightText: sertifikat.farmName,
                ),
                SizedBox(height: Responsive.h(context, 10)),
                _InfoRow(
                  iconPath: sertifikatIconPath,
                  leftText: 'No. Sertifikat E-Hara',
                  rightText: sertifikat.eHaraCertificateNumber,
                ),
                SizedBox(height: Responsive.h(context, 10)),
                _InfoRow(
                  iconPath: sertifikatIconPath,
                  leftText: 'No. Sertifikat\nGanomon',
                  rightText: sertifikat.ganomonCertificateNumber,
                ),
                SizedBox(height: Responsive.h(context, 18)),
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(context, 44),
                  child: ElevatedButton(
                    onPressed: sertifikat.isPublished ? onDownload : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF4A8A76),
                      disabledBackgroundColor: const Color(0xFFD5DDDA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.r(context, 10),
                        ),
                      ),
                    ),
                    child: Text(
                      'Download Sertifikat',
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

  const _InfoRow({
    required this.iconPath,
    required this.leftText,
    this.rightText,
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
                  style: textStyle,
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