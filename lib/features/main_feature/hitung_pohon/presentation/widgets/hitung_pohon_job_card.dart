import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../models/hitung_pohon_job_model.dart';

class HitungPohonJobCard extends StatelessWidget {
  const HitungPohonJobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  final HitungPohonJobModel job;
  final VoidCallback onTap;

  String _dateText(DateTime? date) {
    if (date == null) return '-';
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year}';
  }

  Color get _statusColor {
    if (job.isDone) return AppColors.primary;
    if (job.isFailed) return AppColors.error;
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Text(
              job.filename,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bold(fontSize: 17),
            ),
          ),
          Container(height: 2, color: AppColors.primary),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            child: Column(
              children: [
                _InfoRow(icon: Icons.calendar_month, label: 'Tanggal', value: _dateText(job.createdAt)),
                _InfoRow(icon: Icons.tag_rounded, label: 'Total Pohon', value: '${job.classCounts.total}'),
                _InfoRow(icon: Icons.info_outline, label: 'Status Quick Count', value: job.status, valueColor: _statusColor),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('Hasil Hitung', style: AppTextStyles.semiBold(fontSize: 12, color: Colors.white)),
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
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textPrimary.withOpacity(0.75)),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: Text(label, style: AppTextStyles.semiBold(fontSize: 12))),
          Text(': ', style: AppTextStyles.semiBold(fontSize: 12)),
          Expanded(
            flex: 4,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.semiBold(fontSize: 12, color: valueColor ?? AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
