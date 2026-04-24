import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../../list_kebun/models/kebun_feature_type.dart';
import '../../../list_kebun/models/kebun_model.dart';
import '../../../list_kebun/providers/kebun_selection_controller.dart';
import '../../models/riwayat_model.dart';
import '../../providers/riwayat_controller.dart';
import '../../providers/riwayat_state.dart';
import '../widgets/riwayat_card.dart';
import '../widgets/riwayat_empty_state.dart';
import '../widgets/riwayat_filter_dialog.dart';

class RiwayatPage extends ConsumerWidget {
  const RiwayatPage({super.key});

  Future<void> _openFilterDialog(
      BuildContext context,
      WidgetRef ref,
      RiwayatState state,
      ) async {
    final result = await showDialog<RiwayatFilterResult>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => RiwayatFilterDialog(
        initialStartDate: state.startDate,
        initialEndDate: state.endDate,
        initialSortType: state.sortType,
      ),
    );

    if (result != null) {
      ref.read(riwayatControllerProvider.notifier).applyFilter(
        startDate: result.startDate,
        endDate: result.endDate,
        sortType: result.sortType,
      );
    }
  }

  /// FLOW:
  /// Riwayat -> List Kebun
  /// dan feature yang dipilih tetap EHARA
  void _onTapHasilAnalisis(
      BuildContext context,
      WidgetRef ref,
      RiwayatModel item,
      ) {
    final controller = ref.read(kebunSelectionControllerProvider.notifier);

    controller.setSelectedFeature(KebunFeatureType.ehara);

    controller.setSelectedKebun(
      KebunModel(
        id: item.id,
        namaKebun: item.farmName,
        totalPohon: 0,
        tanggalAnalisis: item.date,
        tanggalPengambilanData: item.date,
        eHaraUuid: item.eHaraUuid,
        nomorSertifikat: '',
      ),
    );

    context.push(AppRoutes.listKebun);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(riwayatControllerProvider);
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppTopBar(
                title: 'Riwayat Analisis',
                showBackButton: false,
                onActionTap: () => _openFilterDialog(context, ref, state),
                actionIconPath: 'assets/icons/filter.png',
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    switch (state.viewState) {
                      case RiwayatViewState.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      case RiwayatViewState.empty:
                        return const RiwayatEmptyState(
                          title: 'Data belum ditemukan!',
                          description:
                          'Klik tombol “Tambah Analisis” untuk mulai tambah analisis pertama kamu!',
                          imagePath: 'assets/images/ehara_robot_empty.png',
                        );

                      case RiwayatViewState.error:
                        return RiwayatEmptyState(
                          title: 'Data belum ditemukan!',
                          description: state.errorMessage ??
                              'Coba sesuaikan filter kamu!',
                          showClockBadge: true,
                          imagePath: 'assets/images/ehara_robot_empty.png',
                        );

                      case RiwayatViewState.success:
                        final items = state.filteredItems;

                        return RefreshIndicator(
                          onRefresh: () => ref
                              .read(riwayatControllerProvider.notifier)
                              .loadRiwayat(),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              isSmall ? 12 : 16,
                              isSmall ? 16 : 20,
                              isSmall ? 12 : 16,
                              90 + bottomSafeArea,
                            ),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: isSmall ? 14 : 18),
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return RiwayatCard(
                                riwayat: item,
                                onTapDetail: () =>
                                    _onTapHasilAnalisis(context, ref, item),
                                calendarIconPath: 'assets/icons/calendar.png',
                                kebunIconPath: 'assets/icons/kebun.png',
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