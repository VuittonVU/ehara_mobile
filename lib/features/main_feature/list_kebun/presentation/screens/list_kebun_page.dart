import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/widgets/app_background.dart';
import '../../../../../../../core/widgets/app_top_bar.dart';

import '../../../ehara/providers/ehara_controller.dart';
import '../../../ganoderma/providers/ganoderma_controller.dart';
import '../../../rekomendasi_pemupukan/providers/rekomendasi_pemupukan_controller.dart';

import '../../models/kebun_feature_type.dart';
import '../../models/kebun_model.dart';
import '../../providers/kebun_controller.dart';
import '../../providers/kebun_selection_controller.dart';
import '../../../../../../../core/widgets/app_state_view.dart';
import '../widgets/kebun_filter_dialog.dart';

class ListKebunPage extends ConsumerWidget {
  const ListKebunPage({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  Future<void> _openFilterDialog(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final controller = ref.read(kebunControllerProvider.notifier);

    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.30),
      builder: (_) => KebunFilterDialog(
        initialFilter: controller.filter,
      ),
    );

    if (result != null) {
      controller.applyFilter(result);
    }
  }

  void _prefetchSelectedFeature(
      WidgetRef ref,
      KebunFeatureType feature,
      String uuid,
      ) {
    switch (feature) {
      case KebunFeatureType.ehara:
        ref.read(eharaControllerProvider.notifier).loadDashboard(
          eHaraUuid: uuid,
        );
        break;

      case KebunFeatureType.rekomendasiPemupukan:
        ref.read(rekomendasiPemupukanControllerProvider.notifier).load(
          eHaraUuid: uuid,
        );
        break;

      case KebunFeatureType.ganoderma:
        ref.read(ganodermaControllerProvider.notifier).load(
          eHaraUuid: uuid,
        );
        break;
    }
  }

  void _handleTapKebun(
      BuildContext context,
      WidgetRef ref,
      KebunModel item,
      KebunFeatureType? feature,
      ) {
    if (feature == null) return;

    final uuid = item.eHaraUuid;

    ref.read(kebunSelectionControllerProvider.notifier).setSelectedKebun(item);

    _prefetchSelectedFeature(ref, feature, uuid);

    switch (feature) {
      case KebunFeatureType.ehara:
        context.pushNamed(
          'ehara',
          pathParameters: {
            'uuid': uuid,
          },
        );
        break;

      case KebunFeatureType.rekomendasiPemupukan:
        context.pushNamed(
          'rekomendasiPemupukan',
          pathParameters: {
            'uuid': uuid,
          },
        );
        break;

      case KebunFeatureType.ganoderma:
        context.pushNamed(
          'ganoderma',
          pathParameters: {
            'uuid': uuid,
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kebunState = ref.watch(kebunControllerProvider);
    final selection = ref.watch(kebunSelectionControllerProvider);
    final feature = selection.selectedFeature;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppTopBar(
                title: 'List Kebun',
                onBackTap: () => context.pop(),
                onActionTap: () => _openFilterDialog(context, ref),
                backIconPath: 'assets/icons/arrow_back.png',
                actionIconPath: 'assets/icons/filter.png',
              ),
              Expanded(
                child: kebunState.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => AppStateView.fromError(
                    message: error.toString(),
                    onRetry: () =>
                        ref.read(kebunControllerProvider.notifier).refresh(),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return AppStateView(
                        type: ref
                                .read(kebunControllerProvider.notifier)
                                .filter
                                .hasActiveFilter
                            ? AppStateType.filterEmpty
                            : AppStateType.empty,
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          ref.read(kebunControllerProvider.notifier).refresh(),
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          isSmall ? 14 : 20,
                          18,
                          isSmall ? 14 : 20,
                          90 + bottomSafeArea,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: isSmall ? 18 : 28),
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return _KebunCard(
                            item: item,
                            isSmall: isSmall,
                            formatDate: _formatDate,
                            onTap: () => _handleTapKebun(
                              context,
                              ref,
                              item,
                              feature,
                            ),
                          );
                        },
                      ),
                    );
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

class _KebunCard extends StatefulWidget {
  final KebunModel item;
  final bool isSmall;
  final String Function(DateTime?) formatDate;
  final VoidCallback onTap;

  const _KebunCard({
    required this.item,
    required this.isSmall,
    required this.formatDate,
    required this.onTap,
  });

  @override
  State<_KebunCard> createState() => _KebunCardState();
}

class _KebunCardState extends State<_KebunCard> {
  bool _isActive = false;

  void _setActive(bool value) {
    if (_isActive == value) return;
    setState(() => _isActive = value);
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF3E806D);

    final bgColor = _isActive ? green : Colors.white;
    final borderColor = _isActive ? green : const Color(0xFFE0E0E0);
    final labelColor = _isActive ? Colors.white70 : const Color(0xFF7A7A7A);
    final valueColor = _isActive ? Colors.white : const Color(0xFF333333);

    return MouseRegion(
      onEnter: (_) => _setActive(true),
      onExit: (_) => _setActive(false),
      child: GestureDetector(
        onTapDown: (_) => _setActive(true),
        onTapUp: (_) => _setActive(false),
        onTapCancel: () => _setActive(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            widget.isSmall ? 14 : 20,
            widget.isSmall ? 16 : 20,
            widget.isSmall ? 14 : 20,
            widget.isSmall ? 14 : 18,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _InfoBlock(
                      label: 'Nama Kebun',
                      value: widget.item.namaKebun,
                      valueFontSize: widget.isSmall ? 16 : 18,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                  ),
                  SizedBox(width: widget.isSmall ? 12 : 18),
                  _InfoBlock(
                    label: 'Total Pohon',
                    value: widget.item.totalPohon.toString(),
                    valueFontSize: widget.isSmall ? 16 : 18,
                    textAlign: TextAlign.right,
                    labelColor: labelColor,
                    valueColor: valueColor,
                  ),
                ],
              ),
              SizedBox(height: widget.isSmall ? 18 : 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _InfoBlock(
                      label: 'Tgl Analisis',
                      value: widget.formatDate(widget.item.tanggalAnalisis),
                      valueFontSize: widget.isSmall ? 13 : 14,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                  ),
                  SizedBox(width: widget.isSmall ? 8 : 14),
                  Expanded(
                    flex: 1,
                    child: _InfoBlock(
                      label: 'Tgl Ambil Data',
                      value: widget.formatDate(
                        widget.item.tanggalPengambilanData,
                      ),
                      valueFontSize: widget.isSmall ? 13 : 14,
                      textAlign: TextAlign.right,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final double valueFontSize;
  final TextAlign textAlign;
  final Color labelColor;
  final Color valueColor;

  const _InfoBlock({
    required this.label,
    required this.value,
    required this.valueFontSize,
    required this.labelColor,
    required this.valueColor,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = textAlign == TextAlign.right;
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Column(
      crossAxisAlignment:
      isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmall ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w800,
            color: valueColor,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}