import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/analysis_carousel_page.dart';
import '../../../shared/widgets/detail_kebun_card.dart';
import '../widgets/rekomendasi_analisis_hara_chart.dart';
import '../widgets/pemupukan_dosis_section.dart';

class RekomendasiPemupukanPage extends StatelessWidget {
  const RekomendasiPemupukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisCarouselPage(
      titles: const [
        'Detail Kebun',
        'Analisis Hara',
        'Rekomendasi\nPemupukan',
      ],
      onBackTap: () => context.pop(),
      onPdfTap: () {},
      slides: const [
        _RekomSlideOne(),
        _RekomSlideTwo(),
        _RekomSlideThree(),
      ],
    );
  }
}

class _RekomSlideOne extends StatelessWidget {
  const _RekomSlideOne();

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
            SizedBox(height: 18),
            _SingleColumnDetailField(
              label: 'Lokasi',
              value:
              'Jl. Brigjend Katamso No.51, Kp. Baru, Kec. Medan Maimun, Kota Medan, Sumatera Utara 20158',
              valueFontSize: 15,
              valueHeight: 1.12,
            ),
            SizedBox(height: 18),
            DetailKebunTwoColumnRow(
              leftLabel: 'Tahun Tanam',
              leftValue: '2018',
              rightLabel: 'Nomor Blok',
              rightValue: 'A-01',
            ),
            SizedBox(height: 18),
            DetailKebunTwoColumnRow(
              leftLabel: 'Jumlah Pohon/Ha',
              leftValue: '143',
              rightLabel: 'Nomor KCD',
              rightValue: 'Kwala Sawit',
            ),
            SizedBox(height: 18),
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: '12',
              rightLabel: 'Luas Ha',
              rightValue: '25',
            ),
            SizedBox(height: 18),
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

class _RekomSlideTwo extends StatelessWidget {
  const _RekomSlideTwo();

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
        RekomendasiAnalisisHaraChart(),
      ],
    );
  }
}

class _RekomSlideThree extends StatelessWidget {
  const _RekomSlideThree();

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
        SizedBox(height: 16),
        PemupukanDosisSection(
          title: 'Dosis/Total Area',
          items: [
            PemupukanDoseItem(
              title: 'Urea',
              minimum: '2.75',
              maksimum: '2.75',
            ),
            PemupukanDoseItem(
              title: 'TSP',
              minimum: '2.75',
              maksimum: '2.75',
            ),
            PemupukanDoseItem(
              title: 'MSP',
              minimum: '2.75',
              maksimum: '2.75',
            ),
            PemupukanDoseItem(
              title: 'Dolomit',
              minimum: '2.25',
              maksimum: '2.25',
            ),
          ],
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF787878),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            softWrap: true,
            style: TextStyle(
              fontSize: valueFontSize,
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