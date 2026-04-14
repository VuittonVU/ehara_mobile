import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_top_bar.dart';
import 'models/kebun_feature_type.dart';
import 'models/kebun_model.dart';
import 'providers/kebun_list_provider.dart';
import 'providers/kebun_selection_controller.dart';

class ListKebunPage extends ConsumerWidget {
  const ListKebunPage({super.key});

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  void _handleTapKebun(
      BuildContext context,
      WidgetRef ref,
      KebunModel item,
      KebunFeatureType? feature,
      ) {
    if (feature == null) return;

    ref.read(kebunSelectionControllerProvider.notifier).setSelectedKebun(item);

    switch (feature) {
      case KebunFeatureType.ehara:
        context.push(AppRoutes.ehara);
        break;
      case KebunFeatureType.rekomendasiPemupukan:
        context.push(AppRoutes.rekomendasiPemupukan);
        break;
      case KebunFeatureType.ganoderma:
        context.push(AppRoutes.ganoderma);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(kebunListProvider);
    final selection = ref.watch(kebunSelectionControllerProvider);
    final feature = selection.selectedFeature;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppTopBar(
                title: 'List Kebun',
                onBackTap: () => context.pop(),
                onActionTap: () {},
                backIconPath: 'assets/icons/arrow_back.png',
                actionIconPath: 'assets/icons/filter.png',
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    90 + bottomSafeArea,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 22),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () =>
                          _handleTapKebun(context, ref, item, feature),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F7),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFC6C6C6),
                            width: 1.4,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
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
                                    value: item.namaKebun,
                                    valueFontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                _InfoBlock(
                                  label: 'Total Pohon',
                                  value: item.totalPohon.toString(),
                                  valueFontSize: 18,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _InfoBlock(
                                    label: 'Tanggal Analisis',
                                    value: _formatDate(item.tanggalAnalisis),
                                    valueFontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _InfoBlock(
                                    label: 'Date Pengambilan Data',
                                    value:
                                    _formatDate(item.tanggalPengambilanData),
                                    valueFontSize: 14,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final double valueFontSize;
  final TextAlign textAlign;

  const _InfoBlock({
    required this.label,
    required this.value,
    required this.valueFontSize,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = textAlign == TextAlign.right;

    return Column(
      crossAxisAlignment:
      isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A7A7A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF333333),
            height: 1.1,
          ),
        ),
      ],
    );
  }
}