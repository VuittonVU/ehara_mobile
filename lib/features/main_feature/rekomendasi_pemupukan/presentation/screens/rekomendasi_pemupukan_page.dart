import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared_analysis/widgets/analysis_carousel_page.dart';
import '../../../shared_analysis/widgets/detail_kebun_card.dart';
import '../../models/rekomendasi_pemupukan_model.dart';
import '../../providers/rekomendasi_pemupukan_controller.dart';
import '../widgets/rekomendasi_analisis_hara_chart.dart';
import '../widgets/pemupukan_dosis_section.dart';

class RekomendasiPemupukanPage extends ConsumerStatefulWidget {
  final String eHaraUuid;

  const RekomendasiPemupukanPage({
    super.key,
    required this.eHaraUuid,
  });

  @override
  ConsumerState<RekomendasiPemupukanPage> createState() =>
      _RekomendasiPemupukanPageState();
}

class _RekomendasiPemupukanPageState
    extends ConsumerState<RekomendasiPemupukanPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(rekomendasiPemupukanControllerProvider.notifier).load(
        eHaraUuid: widget.eHaraUuid,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rekomendasiPemupukanControllerProvider);

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
                    ref.read(rekomendasiPemupukanControllerProvider.notifier).load(
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
        body: Center(child: Text('Data rekomendasi tidak ditemukan')),
      );
    }

    return AnalysisCarouselPage(
      titles: const [
        'Detail Kebun',
        'Analisis Hara',
        'Rekomendasi\nPemupukan',
      ],
      onBackTap: () => context.pop(),
      onPdfTap: () {},
      slides: [
        _RekomSlideOne(data: data),
        _RekomSlideTwo(data: data),
        _RekomSlideThree(data: data),
      ],
    );
  }
}

class _RekomSlideOne extends StatelessWidget {
  final RekomendasiPemupukanModel data;

  const _RekomSlideOne({
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
            const SizedBox(height: 18),
            _SingleColumnDetailField(
              label: 'Lokasi',
              value: data.lokasi,
              valueFontSize: 15,
              valueHeight: 1.12,
            ),
            const SizedBox(height: 18),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: data.tahunTanam,
              rightLabel: 'Nomor Blok',
              rightValue: data.nomorBlok,
            ),
            const SizedBox(height: 18),
            DetailKebunTwoColumnRow(
              leftLabel: 'Jumlah Pohon/Ha',
              leftValue: data.jumlahPohonPerHa,
              rightLabel: 'Nomor KCD',
              rightValue: data.nomorKcd,
            ),
            const SizedBox(height: 18),
            DetailKebunTwoColumnRow(
              leftLabel: 'Umur Tanaman',
              leftValue: data.umurTanaman,
              rightLabel: 'Luas Ha',
              rightValue: data.luasHa,
            ),
            const SizedBox(height: 18),
            _SingleColumnDetailField(
              label: 'Produktivitas Tahunan (ton/Ha)',
              value: data.produktivitasTahunan,
            ),
          ],
        ),
      ],
    );
  }
}

class _RekomSlideTwo extends StatelessWidget {
  final RekomendasiPemupukanModel data;

  const _RekomSlideTwo({
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
            _SingleColumnDetailField(
              label: 'Produktivitas Tahunan (ton/Ha)',
              value: data.produktivitasTahunan,
            ),
          ],
        ),
        const SizedBox(height: 22),
        RekomendasiAnalisisHaraChart(
          hasil: [data.n, data.p, data.k, data.mg],
          standar: [
            data.nStandar,
            data.pStandar,
            data.kStandar,
            data.mgStandar,
          ],
        ),
      ],
    );
  }
}

class _RekomSlideThree extends StatelessWidget {
  final RekomendasiPemupukanModel data;

  const _RekomSlideThree({
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
            _SingleColumnDetailField(
              label: 'Produktivitas Tahunan (ton/Ha)',
              value: data.produktivitasTahunan,
            ),
          ],
        ),
        const SizedBox(height: 16),
        PemupukanDosisSection(
          title: 'Dosis/Total Area',
          items: data.dosis
              .map(
                (e) => PemupukanDoseItem(
              title: e.title,
              minimum: e.minimum,
              maksimum: e.maksimum,
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

class _SingleColumnDetailField extends StatelessWidget {
  final String label;
  final String value;
  final double valueFontSize;
  final double valueHeight;

  const _SingleColumnDetailField({
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
              fontSize: isSmall ? 12 : 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF787878),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            softWrap: true,
            style: TextStyle(
              fontSize: isSmall ? valueFontSize - 1.5 : valueFontSize,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3A3A3A),
              height: valueHeight,
            ),
          ),
        ],
      ),
    );
  }
}