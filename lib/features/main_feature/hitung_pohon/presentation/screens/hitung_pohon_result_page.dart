import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/widgets/app_background.dart';
import '../../../../../../../core/widgets/app_state_view.dart';
import '../../models/hitung_pohon_job_model.dart';
import '../../providers/hitung_pohon_controller.dart';

class HitungPohonResultPage extends ConsumerStatefulWidget {
  const HitungPohonResultPage({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<HitungPohonResultPage> createState() => _HitungPohonResultPageState();
}

class _HitungPohonResultPageState extends ConsumerState<HitungPohonResultPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(hitungPohonControllerProvider.notifier).loadJob(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hitungPohonControllerProvider);
    final job = state.currentJob;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 34, color: Color(0xFF202020)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text('Hasil Hitung Pohon', style: AppTextStyles.heading2().copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                )
              else if (state.errorMessage != null)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: AppStateView(
                    type: AppStateType.backendError,
                    description: state.errorMessage,
                    onRetry: () => ref
                        .read(hitungPohonControllerProvider.notifier)
                        .loadJob(widget.jobId),
                  ),
                )
              else if (job != null)
                _ResultContent(job: job),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultContent extends StatelessWidget {
  const _ResultContent({required this.job});

  final HitungPohonJobModel job;

  String _date(DateTime? date) {
    if (date == null) return '-';
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 1.6),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 9, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.filename, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bold(fontSize: 18)),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _CountBox(title: 'Total', value: job.classCounts.total.toString())),
              const SizedBox(width: 10),
              Expanded(child: _CountBox(title: 'Palm', value: job.classCounts.palm.toString())),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _CountBox(title: 'Fade Palm', value: job.classCounts.fadePalm.toString())),
              const SizedBox(width: 10),
              Expanded(child: _CountBox(title: 'Green Young', value: job.classCounts.fadePalmGreenYoung.toString())),
            ],
          ),
          const SizedBox(height: 22),
          _InfoTile(label: 'Status', value: '${job.status} (${job.progress}%)'),
          _InfoTile(label: 'Tiles', value: '${job.tilesProcessed}/${job.totalGridTiles}'),
          _InfoTile(label: 'Waktu Proses', value: '${job.elapsedSeconds ?? 0} detik'),
          _InfoTile(label: 'Tanggal Upload', value: _date(job.createdAt)),
          _InfoTile(label: 'CRS', value: job.tifInfo.crs),
          _InfoTile(label: 'Ukuran Citra', value: '${job.tifInfo.width} x ${job.tifInfo.height}'),
          _InfoTile(label: 'Bands', value: '${job.tifInfo.bands} (${job.tifInfo.dtype})'),
          _InfoTile(label: 'Ukuran File', value: job.formattedFileSize),
        ],
      ),
    );
  }
}

class _CountBox extends StatelessWidget {
  const _CountBox({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.medium(fontSize: 12, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.extraBold(fontSize: 22, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: Text(label, style: AppTextStyles.semiBold(fontSize: 12))),
          Text(': ', style: AppTextStyles.semiBold(fontSize: 12)),
          Expanded(flex: 6, child: Text(value, style: AppTextStyles.regular(fontSize: 12))),
        ],
      ),
    );
  }
}
