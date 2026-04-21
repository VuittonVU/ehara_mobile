import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared_analysis/widgets/analysis_carousel_page.dart';
import '../../../shared_analysis/widgets/analysis_section_card.dart';
import '../../../shared_analysis/widgets/detail_kebun_card.dart';
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
    return const Column(
      children: [
        _EHaraDetailKebunCard(),
      ],
    );
  }
}

class _EHaraSlideTwo extends StatelessWidget {
  const _EHaraSlideTwo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
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
    return const Column(
      children: [
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
    return const Column(
      children: [
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
    final isSmall = MediaQuery.of(context).size.width < 360;

    return AnalysisSectionCard(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 18 : 26,
        isSmall ? 22 : 28,
        isSmall ? 18 : 26,
        isSmall ? 24 : 30,
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
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isSmall ? 40 : 46,
          height: isSmall ? 40 : 46,
          decoration: BoxDecoration(
            color: const Color(0xFF4A8A76),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: isSmall ? 18 : 22,
              height: isSmall ? 18 : 22,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: isSmall ? 10 : 12),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmall ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4A4A4A),
          ),
        ),
        SizedBox(width: isSmall ? 8 : 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isSmall ? 14 : 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF333333),
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
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Column(
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
    );
  }
}