import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared_analysis/widgets/analysis_carousel_page.dart';
import '../../../shared_analysis/widgets/detail_kebun_card.dart';
import '../../models/ganoderma_model.dart';
import '../../providers/ganoderma_controller.dart';
import '../widgets/ganoderma_map_section.dart';
import '../widgets/ganoderma_summary_section.dart';

class GanodermaPage extends ConsumerStatefulWidget {
  final String eHaraUuid;

  const GanodermaPage({
    super.key,
    required this.eHaraUuid,
  });

  @override
  ConsumerState<GanodermaPage> createState() => _GanodermaPageState();
}

class _GanodermaPageState extends ConsumerState<GanodermaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ganodermaControllerProvider.notifier).load(
        eHaraUuid: widget.eHaraUuid,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ganodermaControllerProvider);

    if (state.isLoading && state.data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null && state.data == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(ganodermaControllerProvider.notifier).load(
                      eHaraUuid: widget.eHaraUuid,
                    );
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final data = state.data;
    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('Data ganoderma tidak ditemukan')),
      );
    }

    return AnalysisCarouselPage(
      titles: const [
        'Detail Kebun',
        'Ganoderma',
        'Ganoderma',
      ],
      onBackTap: () => context.pop(),
      onPdfTap: () {},
      slides: [
        _GanodermaSlideOne(data: data),
        _GanodermaSlideTwo(data: data),
        _GanodermaSlideThree(data: data),
      ],
    );
  }
}

class _GanodermaSlideOne extends StatelessWidget {
  final GanodermaModel data;

  const _GanodermaSlideOne({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: data.namaKebun,
              rightLabel: 'Tanggal Analisis',
              rightValue: data.tanggalAnalisis,
            ),
            const SizedBox(height: 12),
            _GanodermaSingleField(
              label: 'Lokasi',
              value: data.lokasi,
              valueFontSize: 15,
              valueHeight: 1.08,
            ),
            const SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: data.tahunTanam,
              rightLabel: 'Nomor Blok',
              rightValue: data.nomorBlok,
            ),
            const SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Jumlah Pohon/Ha',
              leftValue: data.jumlahPohonPerHa,
              rightLabel: 'Luas Ha',
              rightValue: data.luasHa,
            ),
            const SizedBox(height: 12),
            _GanodermaSingleField(
              label: 'Produktivitas Tahunan (ton/Ha)',
              value: data.produktivitasTahunan,
            ),
          ],
        ),
      ],
    );
  }
}

class _GanodermaSlideTwo extends StatelessWidget {
  final GanodermaModel data;

  const _GanodermaSlideTwo({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: data.namaKebun,
              rightLabel: 'Tanggal Analisis',
              rightValue: data.tanggalAnalisis,
            ),
            const SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: data.tahunTanam,
              rightLabel: 'Luas Ha',
              rightValue: data.luasHa,
            ),
            const SizedBox(height: 12),
            _GanodermaSingleField(
              label: 'Produktivitas Tahunan (ton/Ha)',
              value: data.produktivitasTahunan,
            ),
          ],
        ),
        const SizedBox(height: 22),
        GanodermaMapSection(data: data),
      ],
    );
  }
}

class _GanodermaSlideThree extends StatelessWidget {
  final GanodermaModel data;

  const _GanodermaSlideThree({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: data.namaKebun,
              rightLabel: 'Tanggal Analisis',
              rightValue: data.tanggalAnalisis,
            ),
            const SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: data.tahunTanam,
              rightLabel: 'Luas Ha',
              rightValue: data.luasHa,
            ),
            const SizedBox(height: 12),
            _GanodermaSingleField(
              label: 'Produktivitas Tahunan (ton/Ha)',
              value: data.produktivitasTahunan,
            ),
          ],
        ),
        const SizedBox(height: 22),
        GanodermaSummarySection(data: data),
      ],
    );
  }
}

class _GanodermaSingleField extends StatelessWidget {
  final String label;
  final String value;
  final double valueFontSize;
  final double valueHeight;

  const _GanodermaSingleField({
    required this.label,
    required this.value,
    this.valueFontSize = 17,
    this.valueHeight = 1.08,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7A7A7A),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            softWrap: true,
            style: TextStyle(
              fontSize: isSmall ? valueFontSize - 1.5 : valueFontSize,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF333333),
              height: valueHeight,
            ),
          ),
        ],
      ),
    );
  }
}