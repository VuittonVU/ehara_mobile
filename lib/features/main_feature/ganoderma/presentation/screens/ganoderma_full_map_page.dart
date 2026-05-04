import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../shared_analysis/services/download_service.dart';
import '../../../shared_analysis/widgets/analysis_top_bar.dart';
import '../../models/ganoderma_model.dart';
import '../widgets/ganoderma_interactive_map.dart';

class GanodermaFullMapPage extends ConsumerStatefulWidget {
  final GanodermaModel data;

  const GanodermaFullMapPage({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<GanodermaFullMapPage> createState() =>
      _GanodermaFullMapPageState();
}

class _GanodermaFullMapPageState extends ConsumerState<GanodermaFullMapPage> {
  bool _isDownloading = false;

  Future<void> _downloadCsv() async {
    if (_isDownloading) return;

    final csvUrl = widget.data.csvUrl;

    if (csvUrl == null || csvUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link CSV ganoderma belum tersedia.'),
        ),
      );
      return;
    }

    setState(() => _isDownloading = true);

    try {
      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour}${now.minute}${now.second}';

      await DownloadService.downloadAndOpenFile(
        url: csvUrl,
        fileName:
        'ganoderma_${widget.data.eHaraUuid.isEmpty ? 'data' : widget.data.eHaraUuid}_$timestamp.csv',
        ref: ref,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          content: Text('File berhasil diunduh.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
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
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      body: Stack(
        children: [
          AppBackground(
            child: SafeArea(
              child: Column(
                children: [
                  AnalysisTopBar(
                    title: 'Peta Ganoderma',
                    onBackTap: () => context.pop(),
                    onDownloadTap: _downloadCsv,
                  ),
                  SizedBox(height: isSmall ? 12 : 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isSmall ? 14 : 20,
                        0,
                        isSmall ? 14 : 20,
                        isSmall ? 14 : 20,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(isSmall ? 24 : 28),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmall ? 10 : 14),
                          child: GanodermaInteractiveMap(
                            points: widget.data.points,
                            showLegend: true,
                            showControls: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isDownloading)
            Container(
              color: Colors.black.withOpacity(0.18),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}