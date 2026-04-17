import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/analysis_carousel_page.dart';
import '../../../shared/widgets/analysis_section_card.dart';
import '../../../shared/widgets/detail_kebun_card.dart';
import '../widgets/ehara_mapping_section.dart';
import '../widgets/ehara_npkmg_section.dart';
import '../widgets/ehara_status_section.dart';

class EHaraPage extends StatelessWidget {
  const EHaraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisCarouselPage(
      titles: const [
        'Detail Kebun',
        'Kandungan\nN,P,K,Mg',
        'Status Hara',
        'Pemetaan\nHara',
      ],
      onBackTap: () => context.pop(),
      onPdfTap: () {},
      slides: const [
        _EHaraSlideOne(),
        _EHaraSlideTwo(),
        _EHaraSlideThree(),
        _EHaraSlideFour(),
      ],
    );
  }
}

class _EHaraSlideOne extends StatelessWidget {
  const _EHaraSlideOne();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _EHaraDetailKebunCard(),
      ],
    );
  }
}

class _EHaraSlideTwo extends StatelessWidget {
  const _EHaraSlideTwo();

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
          ],
        ),
        SizedBox(height: 26),
        EHaraNpkmgSection(),
      ],
    );
  }
}

class _EHaraSlideThree extends StatelessWidget {
  const _EHaraSlideThree();

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
          ],
        ),
        SizedBox(height: 26),
        EHaraStatusSection(),
      ],
    );
  }
}

class _EHaraSlideFour extends StatelessWidget {
  const _EHaraSlideFour();

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
          ],
        ),
        SizedBox(height: 26),
        EHaraMappingSection(),
      ],
    );
  }
}

class _EHaraDetailKebunCard extends StatelessWidget {
  const _EHaraDetailKebunCard();

  @override
  Widget build(BuildContext context) {
    return AnalysisSectionCard(
      padding: const EdgeInsets.fromLTRB(
        26,
        28,
        26,
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _IconInfoRow(
            iconPath: 'assets/icons/pohon.png',
            label: 'Total Pohon:',
            value: '286',
          ),
          SizedBox(height: 20),
          _IconInfoRow(
            iconPath: 'assets/icons/camera.png',
            label: 'Jenis Sensor:',
            value: 'MicaSense',
          ),
          SizedBox(height: 36),
          _SingleField(
            label: 'Nama Kebun',
            value: 'Kwala Sawit',
          ),
          SizedBox(height: 28),
          _SingleField(
            label: 'No. Sertifikat',
            value: 'EH/001/III/2026',
          ),
          SizedBox(height: 28),
          _SingleField(
            label: 'Tanggal Analisis',
            value: '09-03-2026',
          ),
          SizedBox(height: 28),
          _SingleField(
            label: 'Lokasi',
            value:
            'Jl. Brigjend Katamso No.51, Kp. Baru, Kec. Medan Maimun, Kota Medan, Sumatera Utara 20158',
            valueFontSize: 15,
            valueHeight: 1.2,
          ),
        ],
      ),
    );
  }
}

class _IconInfoRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _IconInfoRow({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF4A8A76),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}

class _SingleField extends StatelessWidget {
  final String label;
  final String value;
  final double valueFontSize;
  final double valueHeight;

  const _SingleField({
    required this.label,
    required this.value,
    this.valueFontSize = 17,
    this.valueHeight = 1.1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}