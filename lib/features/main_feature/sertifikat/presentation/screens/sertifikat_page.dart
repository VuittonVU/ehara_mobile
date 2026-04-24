import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../models/sertifikat_model.dart';
import '../../providers/sertifikat_controller.dart';
import '../../providers/sertifikat_state.dart';
import '../../services/sertifikat_service.dart';
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

  Future<void> _downloadSinglePdf({
    required BuildContext context,
    required WidgetRef ref,
    required String filename,
    required String suggestedName,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(sertifikatServiceProvider);

    messenger.showSnackBar(
      const SnackBar(content: Text('Sedang mengunduh sertifikat...')),
    );

    try {
      final file = await service.downloadCertificatePdf(
        filename: filename,
        suggestedName: suggestedName,
      );

      await OpenFilex.open(file.path);

      messenger.showSnackBar(
        SnackBar(content: Text('PDF dibuka: ${file.path.split('/').last}')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal download PDF: $e')),
      );
    }
  }

  Future<void> _onDownload(
      BuildContext context,
      WidgetRef ref,
      SertifikatModel sertifikat,
      ) async {
    final hasEhara = sertifikat.hasEHarapdf;
    final hasGanomon = sertifikat.hasGanomonPdf;

    if (!hasEhara && !hasGanomon) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File PDF belum tersedia')),
      );
      return;
    }

    if (hasEhara && !hasGanomon) {
      await _downloadSinglePdf(
        context: context,
        ref: ref,
        filename: sertifikat.eHaraPdfFilename!,
        suggestedName: '${sertifikat.projectName}_EHARA',
      );
      return;
    }

    if (!hasEhara && hasGanomon) {
      await _downloadSinglePdf(
        context: context,
        ref: ref,
        filename: sertifikat.ganomonPdfFilename!,
        suggestedName: '${sertifikat.projectName}_GANODERMA',
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Sertifikat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('Sertifikat E-Hara'),
                  subtitle: Text(sertifikat.eHaraCertificateNumber),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _downloadSinglePdf(
                      context: context,
                      ref: ref,
                      filename: sertifikat.eHaraPdfFilename!,
                      suggestedName: '${sertifikat.projectName}_EHARA',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('Sertifikat Ganoderma'),
                  subtitle: Text(sertifikat.ganomonCertificateNumber),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _downloadSinglePdf(
                      context: context,
                      ref: ref,
                      filename: sertifikat.ganomonPdfFilename!,
                      suggestedName: '${sertifikat.projectName}_GANODERMA',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sertifikatControllerProvider);
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
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
                          description: state.errorMessage ??
                              'Coba sesuaikan pencarian atau filter anda!',
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
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 18),
                            itemBuilder: (context, index) {
                              final item = certificates[index];
                              return SertifikatCard(
                                sertifikat: item,
                                onDownload: () => _onDownload(context, ref, item),
                                calendarIconPath: 'assets/icons/calendar.png',
                                kebunIconPath: 'assets/icons/kebun.png',
                                sertifikatIconPath:
                                'assets/icons/badge-check.png',
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
      ),
    );
  }
}