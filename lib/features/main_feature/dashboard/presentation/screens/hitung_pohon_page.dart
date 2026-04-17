import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';

class HitungPohonPage extends StatelessWidget {
  const HitungPohonPage({super.key});

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 34,
                        color: Color(0xFF202020),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        'Hitung Jumlah Pohon',
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catatan:',
                        style: AppTextStyles.semiBold(
                          fontSize: 13,
                          color: const Color(0xFFE0A100),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Unggah file citra drone yang sudah memiliki metadata NIR (Near-Infrared) untuk akurasi deteksi pohon. Gunakan opsi Google Drive untuk proses unggah yang lebih stabil pada file berukuran besar.',
                        style: AppTextStyles.regular(
                          fontSize: 13,
                          color: AppColors.textPrimary.withOpacity(0.72),
                        ).copyWith(height: 1.45),
                      ),
                      const SizedBox(height: 22),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _showInfo(
                            context,
                            'Fitur pilih file belum diaktifkan.',
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 154,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.textPrimary.withOpacity(0.35),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 64,
                                color: AppColors.textPrimary.withOpacity(0.42),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Unggah File',
                                style: AppTextStyles.medium(
                                  fontSize: 16,
                                  color: AppColors.textPrimary.withOpacity(0.55),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'File yang dipilih harus berformat .tiff',
                        style: AppTextStyles.regular(
                          fontSize: 12,
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            _showInfo(
                              context,
                              'Fitur upload dan hitung pohon belum diaktifkan.',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Upload dan Lanjutkan',
                            style: AppTextStyles.semiBold(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}