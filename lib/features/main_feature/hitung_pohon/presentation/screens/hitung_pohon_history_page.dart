import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../providers/hitung_pohon_controller.dart';
import '../widgets/hitung_pohon_job_card.dart';

class HitungPohonHistoryPage extends ConsumerStatefulWidget {
  const HitungPohonHistoryPage({super.key});

  @override
  ConsumerState<HitungPohonHistoryPage> createState() => _HitungPohonHistoryPageState();
}

class _HitungPohonHistoryPageState extends ConsumerState<HitungPohonHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(hitungPohonControllerProvider.notifier).loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hitungPohonControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(hitungPohonControllerProvider.notifier).loadHistory(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 28),
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
                      child: Text(
                        'Riwayat Hitung\nJumlah Pohon',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading2().copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 52),
                  ],
                ),
                const SizedBox(height: 32),
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  )
                else if (state.errorMessage != null)
                  _EmptyMessage(message: state.errorMessage!)
                else if (state.history.isEmpty)
                  const _EmptyMessage(message: 'Belum ada riwayat hitung pohon.')
                else
                  ...state.history.map(
                    (job) => HitungPohonJobCard(
                      job: job,
                      onTap: () => context.push('${AppRoutes.hitungPohonResult}/${job.id}'),
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

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.medium(fontSize: 14, color: AppColors.textPrimary.withOpacity(0.65)),
        ),
      ),
    );
  }
}
