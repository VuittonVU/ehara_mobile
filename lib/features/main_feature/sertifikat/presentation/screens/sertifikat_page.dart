import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/app_top_bar.dart';
import '../../models/sertifikat_model.dart';
import '../../providers/sertifikat_controller.dart';
import '../../providers/sertifikat_state.dart';
import '../widgets/sertifikat_card.dart';
import '../widgets/sertifikat_empty_state.dart';
import '../widgets/sertifikat_filter_dialog.dart';

class SertifikatPage extends ConsumerWidget {
  const SertifikatPage({super.key});

  Future<void> _openFilterDialog(
      BuildContext context,
      WidgetRef ref,
      SertifikatState state,
      ) async {
    final result = await showDialog<SertifikatFilterResult>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => SertifikatFilterDialog(
        initialStartDate: state.startDate,
        initialEndDate: state.endDate,
        initialSortType: state.sortType,
        initialPublishedStatus: state.publishedStatus,
      ),
    );

    if (result != null) {
      ref.read(sertifikatControllerProvider.notifier).applyFilter(
        startDate: result.startDate,
        endDate: result.endDate,
        sortType: result.sortType,
        publishedStatus: result.publishedStatus,
      );
    }
  }

  void _onDownload(BuildContext context, SertifikatModel sertifikat) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Download sertifikat ${sertifikat.eHaraCertificateNumber}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sertifikatControllerProvider);
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Sertifikat',
              onBackTap: () => Navigator.of(context).pop(),
              onActionTap: () => _openFilterDialog(context, ref, state),
              backIconPath: 'assets/icons/arrow_back.png',
              actionIconPath: 'assets/icons/filter.png',
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (state.viewState) {
                    case SertifikatViewState.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case SertifikatViewState.empty:
                      return const SertifikatEmptyState(
                        title: 'Data belum ditemukan!',
                        description:
                        'Klik tombol “Tambah Analisis” untuk mulai tambah analisis pertama kamu dan optimalkan hasil panen sekarang!',
                      );

                    case SertifikatViewState.error:
                      return SertifikatEmptyState(
                        title: 'Data belum ditemukan!',
                        description:
                        state.errorMessage ?? 'Coba sesuaikan pencarian atau filter anda!',
                        showClockBadge: true,
                      );

                    case SertifikatViewState.success:
                      final certificates = state.filteredCertificates;

                      return RefreshIndicator(
                        onRefresh: () => ref
                            .read(sertifikatControllerProvider.notifier)
                            .loadCertificates(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            10,
                            20,
                            10,
                            77 + bottomSafeArea,
                          ),
                          itemCount: certificates.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final item = certificates[index];
                            return SertifikatCard(
                              sertifikat: item,
                              onDownload: () => _onDownload(context, item),
                              calendarIconPath: 'assets/icons/calendar.png',
                              kebunIconPath: 'assets/icons/kebun.png',
                              sertifikatIconPath: 'assets/icons/badge-check.png',
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}