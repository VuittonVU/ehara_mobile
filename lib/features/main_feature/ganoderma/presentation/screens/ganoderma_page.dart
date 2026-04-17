import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/analysis_carousel_page.dart';
import '../../../shared/widgets/detail_kebun_card.dart';
import '../widgets/ganoderma_map_section.dart';
import '../widgets/ganoderma_summary_section.dart';

class GanodermaPage extends StatelessWidget {
  const GanodermaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisCarouselPage(
      titles: const [
        'Detail Kebun',
        'Ganoderma',
        'Ganoderma',
      ],
      onBackTap: () => context.pop(),
      onPdfTap: () {},
      slides: const [
        _GanodermaSlideOne(),
        _GanodermaSlideTwo(),
        _GanodermaSlideThree(),
      ],
    );
  }
}

class _GanodermaSlideOne extends StatelessWidget {
  const _GanodermaSlideOne();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: 'Kwala Sawit',
              rightLabel: 'Tanggal Analisis',
              rightValue: '09-03-2026',
            ),
            SizedBox(height: 12),
            _GanodermaSingleField(
              label: 'Lokasi',
              value:
              'Jl. Brigjend Katamso No.51, Kp. Baru, Kec. Medan Maimun, Kota Medan, Sumatera Utara 20158',
              valueFontSize: 15,
              valueHeight: 1.08,
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: '2018',
              rightLabel: 'Nomor Blok',
              rightValue: 'A-01',
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Jumlah Pohon/Ha',
              leftValue: '143',
              rightLabel: 'Nomor KCD',
              rightValue: 'Kwala Sawit',
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: '12',
              rightLabel: 'Luas Ha',
              rightValue: '25',
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Produktivitas Tahunan\n(ton/Ha)',
              leftValue: '22',
              rightLabel: '',
              rightValue: '',
            ),
          ],
        ),
      ],
    );
  }
}

class _GanodermaSlideTwo extends StatelessWidget {
  const _GanodermaSlideTwo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: 'Kwala Sawit',
              rightLabel: 'Tanggal Analisis',
              rightValue: '09-03-2026',
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: '2018',
              rightLabel: 'Luas Ha',
              rightValue: '25',
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Produktivitas Tahunan\n(ton/Ha)',
              leftValue: '22',
              rightLabel: '',
              rightValue: '',
            ),
          ],
        ),
        SizedBox(height: 22),
        GanodermaMapSection(),
      ],
    );
  }
}

class _GanodermaSlideThree extends StatelessWidget {
  const _GanodermaSlideThree();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: 'Kwala Sawit',
              rightLabel: 'Tanggal Analisis',
              rightValue: '09-03-2026',
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: '2018',
              rightLabel: 'Luas Ha',
              rightValue: '25',
            ),
            SizedBox(height: 12),
            DetailKebunTwoColumnRow(
              leftLabel: 'Produktivitas Tahunan\n(ton/Ha)',
              leftValue: '22',
              rightLabel: '',
              rightValue: '',
            ),
          ],
        ),
        SizedBox(height: 22),
        GanodermaSummarySection(),
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7A7A7A),
              height: 1.05,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            softWrap: true,
            style: TextStyle(
              fontSize: valueFontSize,
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