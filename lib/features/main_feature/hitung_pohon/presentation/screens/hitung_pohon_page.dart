import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../app/routes/app_routes.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/widgets/app_background.dart';
import '../../../../../../../core/widgets/app_state_view.dart';
import '../../providers/hitung_pohon_controller.dart';

class HitungPohonPage extends ConsumerStatefulWidget {
  const HitungPohonPage({super.key});

  @override
  ConsumerState<HitungPohonPage> createState() => _HitungPohonPageState();
}

class _HitungPohonPageState extends ConsumerState<HitungPohonPage> {
  File? _selectedFile;
  String? _selectedFileName;
  int? _selectedFileSize;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(hitungPohonControllerProvider.notifier).checkBackendConnection(),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'tif', 'tiff'],
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) return;

    setState(() {
      _selectedFile = File(result.files.single.path!);
      _selectedFileName = result.files.single.name;
      _selectedFileSize = result.files.single.size;
    });
  }

  Future<void> _upload() async {
    if (_selectedFile == null) {
      _showSnack('Pilih file gambar dulu ya.');
      return;
    }

    final job = await ref
        .read(hitungPohonControllerProvider.notifier)
        .uploadAndWait(_selectedFile!);
    final error = ref.read(hitungPohonControllerProvider).errorMessage;

    if (!mounted) return;

    if (job != null) {
      context.push('${AppRoutes.hitungPohonResult}/${job.id}');
    } else if (error != null) {
      _showSnack(error);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return 'Ukuran file tidak terbaca';
    final mb = bytes / (1024 * 1024);
    if (mb >= 1) return '${mb.toStringAsFixed(2)} MB';
    final kb = bytes / 1024;
    return '${kb.toStringAsFixed(1)} KB';
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hitungPohonControllerProvider);
    final currentJob = state.currentJob;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : state.errorMessage != null && !state.isUploading
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                      child: Column(
                        children: [
                          _buildHeader(context),
                          Expanded(
                            child: AppStateView(
                              type: AppStateType.backendError,
                              description: state.errorMessage,
                              onRetry: () => ref
                                  .read(hitungPohonControllerProvider.notifier)
                                  .checkBackendConnection(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
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
                                  'Unggah file citra drone untuk menghitung jumlah pohon. Format yang didukung: JPG, JPEG, PNG, TIF, atau TIFF.',
                                  style: AppTextStyles.regular(
                                    fontSize: 13,
                                    color: AppColors.textPrimary.withOpacity(0.72),
                                  ).copyWith(height: 1.45),
                                ),
                                const SizedBox(height: 22),
                                InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: state.isUploading ? null : _pickFile,
                                  child: Container(
                                    width: double.infinity,
                                    height: 154,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.textPrimary.withOpacity(0.35),
                                      ),
                                    ),
                                    child: _selectedFile == null
                                        ? Column(
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
                                                textAlign: TextAlign.center,
                                                style: AppTextStyles.medium(
                                                  fontSize: 16,
                                                  color: AppColors.textPrimary.withOpacity(0.55),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 72,
                                                  height: 72,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary.withOpacity(0.12),
                                                    borderRadius: BorderRadius.circular(14),
                                                    border: Border.all(
                                                      color: AppColors.primary.withOpacity(0.35),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(
                                                        Icons.image_outlined,
                                                        size: 30,
                                                        color: AppColors.primary,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'IMG',
                                                        style: AppTextStyles.bold(
                                                          fontSize: 11,
                                                          color: AppColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        _selectedFileName ?? '-',
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: AppTextStyles.semiBold(
                                                          fontSize: 14,
                                                          color: AppColors.textPrimary,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        _formatFileSize(_selectedFileSize),
                                                        style: AppTextStyles.regular(
                                                          fontSize: 12,
                                                          color: AppColors.textPrimary.withOpacity(0.62),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.check_circle_rounded,
                                                            size: 16,
                                                            color: AppColors.primary,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(
                                                            'File berhasil dipilih',
                                                            style: AppTextStyles.medium(
                                                              fontSize: 12,
                                                              color: AppColors.primary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'File yang dipilih harus berformat .jpg/.jpeg/.png/.tif/.tiff',
                                  style: AppTextStyles.regular(
                                    fontSize: 12,
                                    color: AppColors.textPrimary.withOpacity(0.7),
                                  ),
                                ),
                                if (state.isUploading) ...[
                                  const SizedBox(height: 18),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: LinearProgressIndicator(
                                      value: currentJob == null
                                          ? null
                                          : (currentJob.progress.clamp(0, 100) / 100),
                                      minHeight: 8,
                                      backgroundColor: AppColors.primary.withOpacity(0.14),
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    currentJob == null
                                        ? 'Mengunggah file...'
                                        : 'Status: ${currentJob.status} • ${currentJob.progress}% • ${currentJob.tilesProcessed}/${currentJob.totalGridTiles} tile',
                                    style: AppTextStyles.medium(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 26),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: state.isUploading ? null : _upload,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: state.isUploading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.4,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
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
