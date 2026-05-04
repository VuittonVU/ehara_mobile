import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../shared_analysis/services/download_service.dart';
import '../../../shared_analysis/widgets/analysis_top_bar.dart';
import '../../models/ehara_model.dart';
import '../../services/ehara_service.dart';
import '../widgets/ehara_map_view.dart';

class EHaraFullMapPage extends ConsumerStatefulWidget {
  final EHaraModel dashboard;

  const EHaraFullMapPage({
    super.key,
    required this.dashboard,
  });

  @override
  ConsumerState<EHaraFullMapPage> createState() => _EHaraFullMapPageState();
}

class _EHaraFullMapPageState extends ConsumerState<EHaraFullMapPage> {
  bool _isDownloading = false;

  Future<void> _downloadHaraCsv() async {
    if (_isDownloading) return;

    final dashboard = widget.dashboard;

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

      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour}${now.minute}${now.second}';

      await DownloadService.downloadAndOpenFile(
        url: url,
        fileName: 'ehara_${safeEstateName}_${dashboard.eHaraUuid}_$timestamp.csv',
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
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      body: Stack(
        children: [
          AppBackground(
            child: SafeArea(
              child: Column(
                children: [
                  AnalysisTopBar(
                    title: 'Peta Sebaran Hara',
                    onBackTap: () => context.pop(),
                    onDownloadTap: _downloadHaraCsv,
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
                        padding: EdgeInsets.all(isSmall ? 10 : 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(isSmall ? 26 : 30),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x18000000),
                              blurRadius: 14,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: EHaraMapView(
                                dashboard: widget.dashboard,
                                fullScreen: true,
                              ),
                            ),
                            Positioned(
                              left: 14,
                              bottom: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x18000000),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Cubit untuk zoom • geser untuk melihat peta',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3E806D),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
      ),
    );
  }
}