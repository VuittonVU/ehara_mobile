import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import '../../models/pembayaran_model.dart';
import '../../providers/pembayaran_controller.dart';
import '../../providers/pembayaran_state.dart';
import '../widgets/pembayaran_card.dart';
import '../widgets/pembayaran_empty_state.dart';
import '../widgets/pembayaran_filter_dialog.dart';

class PembayaranPage extends ConsumerWidget {
  const PembayaranPage({super.key});

  Future<void> _openFilterDialog(
      BuildContext context,
      WidgetRef ref,
      PembayaranState state,
      ) async {
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => PembayaranFilterDialog(
        initialFilter: state.filter,
      ),
    );

    if (result != null) {
      ref.read(pembayaranControllerProvider.notifier).applyFilter(result);
    }
  }

  void _handleCardAction(BuildContext context, WidgetRef ref, String id) {
    final item = ref.read(pembayaranControllerProvider.notifier).findById(id);
    if (item == null) return;

    if (item.status == PembayaranStatus.selesai) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download invoice masih placeholder dulu ya'),
        ),
      );
      return;
    }

    if (item.status == PembayaranStatus.proses) {
      context.push('/proses-pembayaran/$id');
      return;
    }

    if (item.status == PembayaranStatus.dibatalkan) {
      context.push('/menu-pembayaran/$id');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pembayaranControllerProvider);
    final controller = ref.read(pembayaranControllerProvider.notifier);
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppTopBar(
                title: 'Pembayaran',
                showBackButton: false,
                onActionTap: () => _openFilterDialog(context, ref, state),
                actionIconPath: 'assets/icons/filter.png',
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    switch (state.viewState) {
                      case PembayaranViewState.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      case PembayaranViewState.empty:
                        return const PembayaranEmptyState(
                          title: 'Data belum ditemukan!',
                          description:
                          'Belum ada data pembayaran yang cocok. Coba ubah filter untuk melihat data lainnya.',
                          imagePath: 'assets/images/ehara_robot_empty.png',
                        );

                      case PembayaranViewState.error:
                        return PembayaranEmptyState(
                          title: 'Terjadi kesalahan!',
                          description: state.errorMessage ??
                              'Gagal memuat data pembayaran. Coba lagi sebentar.',
                          showClockBadge: true,
                          imagePath: 'assets/images/ehara_robot_empty.png',
                        );

                      case PembayaranViewState.success:
                        final items = state.filteredItems;

                        return RefreshIndicator(
                          onRefresh: () => controller.loadPembayaran(),
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

                              return PembayaranCard(
                                item: item,
                                tanggalText: controller.formatDate(item.tanggal),
                                onPrimaryTap: () =>
                                    _handleCardAction(context, ref, item.id),
                                calendarIconPath: 'assets/icons/calendar.png',
                                kebunIconPath: 'assets/icons/kebun.png',
                                statusIconPath: 'assets/icons/info.png',
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