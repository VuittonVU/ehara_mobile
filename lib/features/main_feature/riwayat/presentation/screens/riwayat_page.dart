import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_top_bar.dart';
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

  void _onTapHasilAnalisis(BuildContext context, String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buka hasil analisis ID: $id'),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(riwayatControllerProvider);
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

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
                          'Klik tombol “Tambah Analisis” untuk mulai tambah analisis pertama kamu dan optimalkan hasil panen sekarang!',
                          imagePath: 'assets/images/ehara_robot_empty.png',
                        );

                      case RiwayatViewState.error:
                        return RiwayatEmptyState(
                          title: 'Data belum ditemukan!',
                          description: state.errorMessage ??
                              'Coba sesuaikan pencarian atau filter anda!',
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
                              10,
                              20,
                              10,
                              80 + bottomSafeArea,
                            ),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 18),
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return RiwayatCard(
                                riwayat: item,
                                onTapDetail: () =>
                                    _onTapHasilAnalisis(context, item.id),
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