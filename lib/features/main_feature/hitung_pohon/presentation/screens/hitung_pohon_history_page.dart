import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_state_view.dart';
import '../../providers/hitung_pohon_controller.dart';
import '../widgets/hitung_pohon_job_card.dart';

class HitungPohonHistoryPage extends ConsumerStatefulWidget {
  const HitungPohonHistoryPage({super.key});

  @override
  ConsumerState<HitungPohonHistoryPage> createState() =>
      _HitungPohonHistoryPageState();
}

class _HitungPohonHistoryPageState extends ConsumerState<HitungPohonHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(hitungPohonControllerProvider.notifier).loadHistory(),
    );
  }

  Future<void> _refreshHistory() {
    return ref.read(hitungPohonControllerProvider.notifier).loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hitungPohonControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshHistory,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 28),
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
                        'Riwayat Hitung\nJumlah Pohon',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 52),
                  ],
                ),
                const SizedBox(height: 32),
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else if (state.errorMessage != null)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: AppStateView.fromError(
                      message: state.errorMessage,
                      onRetry: _refreshHistory,
                    ),
                  )
                else if (state.history.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: const AppStateView(
                      type: AppStateType.empty,
                      title: 'Data belum ditemukan!',
                      description: 'Belum ada riwayat hitung pohon.',
                    ),
                  )
                else
                  ...state.history.map(
                    (job) => HitungPohonJobCard(
                      job: job,
                      onTap: () => context.push(
                        '${AppRoutes.hitungPohonResult}/${job.id}',
                      ),
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
