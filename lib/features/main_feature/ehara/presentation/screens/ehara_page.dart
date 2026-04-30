import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_state_view.dart';
import '../../../shared_analysis/services/download_service.dart';
import '../../../shared_analysis/widgets/analysis_carousel_page.dart';
import '../../../shared_analysis/widgets/analysis_section_card.dart';
import '../../../shared_analysis/widgets/detail_kebun_card.dart';
import '../../models/ehara_model.dart';
import '../../providers/ehara_controller.dart';
import '../../services/ehara_service.dart';
import '../widgets/ehara_mapping_section.dart';
import '../widgets/ehara_npkmg_section.dart';
import '../widgets/ehara_status_section.dart';

class EHaraPage extends ConsumerStatefulWidget {
  final String eHaraUuid;

  const EHaraPage({
    super.key,
    required this.eHaraUuid,
  });

  @override
  ConsumerState<EHaraPage> createState() => _EHaraPageState();
}

class _EHaraPageState extends ConsumerState<EHaraPage> {
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(eharaControllerProvider.notifier).loadDashboard(
        eHaraUuid: widget.eHaraUuid,
      );
    });
  }

  Future<void> _downloadHaraCsv(EHaraModel dashboard) async {
    if (_isDownloading) return;

    if (!dashboard.hasHaraCsv) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File CSV unsur hara belum tersedia.'),
        ),
      );
      return;
    }

    setState(() => _isDownloading = true);

    try {
      final url = EHaraService.buildCsvUrl(
        dashboard.haraCsvFilename,
      );

      final safeEstateName = dashboard.estateName
          .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
          .replaceAll(' ', '_');

      await DownloadService.downloadAndOpenFile(
        url: url,
        fileName: 'ehara_${safeEstateName}_${widget.eHaraUuid}.csv',
        ref: ref,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          content: Text('File berhasil diunduh dan dibuka.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eharaControllerProvider);
    final dashboard = state.dashboard;

    if (state.errorMessage != null && dashboard == null) {
      return Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: AppStateView.fromError(
              message: state.errorMessage,
              onRetry: () {
                ref.read(eharaControllerProvider.notifier).loadDashboard(
                  eHaraUuid: widget.eHaraUuid,
                );
              },
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        if (dashboard != null)
          AnalysisCarouselPage(
            titles: const [
              'Detail Kebun',
              'Kandungan\nN,P,K,Mg',
              'Status Hara',
              'Pemetaan\nHara',
            ],
            onBackTap: () => context.pop(),
            onDownloadTap: () => _downloadHaraCsv(dashboard),
            slides: [
              _EHaraSlideOne(dashboard: dashboard),
              _EHaraSlideTwo(dashboard: dashboard),
              _EHaraSlideThree(dashboard: dashboard),
              _EHaraSlideFour(dashboard: dashboard),
            ],
          )
        else
          const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),

        if (state.isLoading && dashboard != null)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.10),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),

        if (_isDownloading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.18),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

class _EHaraSlideOne extends StatelessWidget {
  final EHaraModel dashboard;

  const _EHaraSlideOne({
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EHaraDetailKebunCard(dashboard: dashboard),
      ],
    );
  }
}

class _EHaraSlideTwo extends StatelessWidget {
  final EHaraModel dashboard;

  const _EHaraSlideTwo({
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: dashboard.estateName,
              rightLabel: 'Tanggal Analisis',
              rightValue: dashboard.analysisDate,
            ),
          ],
        ),
        const SizedBox(height: 26),
        EHaraNpkmgSection(dashboard: dashboard),
      ],
    );
  }
}

class _EHaraSlideThree extends StatelessWidget {
  final EHaraModel dashboard;

  const _EHaraSlideThree({
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: dashboard.estateName,
              rightLabel: 'Tanggal Analisis',
              rightValue: dashboard.analysisDate,
            ),
          ],
        ),
        const SizedBox(height: 26),
        EHaraStatusSection(dashboard: dashboard),
      ],
    );
  }
}

class _EHaraSlideFour extends StatelessWidget {
  final EHaraModel dashboard;

  const _EHaraSlideFour({
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailKebunCard(
          children: [
            DetailKebunTwoColumnRow(
              leftLabel: 'Nama Kebun',
              leftValue: dashboard.estateName,
              rightLabel: 'Tanggal Analisis',
              rightValue: dashboard.analysisDate,
            ),
          ],
        ),
        const SizedBox(height: 26),
        EHaraMappingSection(dashboard: dashboard),
      ],
    );
  }
}

class _EHaraDetailKebunCard extends StatelessWidget {
  final EHaraModel dashboard;

  const _EHaraDetailKebunCard({
    required this.dashboard,
  });

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
        children: [
          _IconInfoRow(
            iconPath: 'assets/icons/pohon.png',
            label: 'Total Pohon:',
            value: dashboard.totalTrees.toString(),
          ),
          const SizedBox(height: 20),
          _IconInfoRow(
            iconPath: 'assets/icons/camera.png',
            label: 'Jenis Sensor:',
            value: dashboard.sensorType,
          ),
          const SizedBox(height: 36),
          _SingleField(
            label: 'Nama Kebun',
            value: dashboard.estateName,
          ),
          const SizedBox(height: 28),
          _SingleField(
            label: 'No. Sertifikat',
            value: dashboard.certificateNumber,
          ),
          const SizedBox(height: 28),
          _SingleField(
            label: 'Tanggal Analisis',
            value: dashboard.analysisDate,
          ),
          const SizedBox(height: 28),
          _SingleField(
            label: 'Lokasi',
            value: dashboard.location,
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