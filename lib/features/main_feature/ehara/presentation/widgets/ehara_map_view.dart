import 'package:flutter/material.dart';

import '../../models/ehara_model.dart';

class EHaraMapView extends StatelessWidget {
  final EHaraModel dashboard;
  final bool fullScreen;

  const EHaraMapView({
    super.key,
    required this.dashboard,
    this.fullScreen = false,
  });

  static const String _mapBaseUrl =
      'https://iopri-storage-prod-ap-southeast-1-001.s3.ap-southeast-1.amazonaws.com/';

  String? _resolveMapUrl() {
    final directUrl = dashboard.mapUrl.trim();
    if (directUrl.isNotEmpty) return directUrl;

    final filename = dashboard.mapFilename.trim();
    if (filename.isEmpty) return null;

    return '$_mapBaseUrl${Uri.encodeComponent(filename)}';
  }

  @override
  Widget build(BuildContext context) {
    final mapUrl = _resolveMapUrl();

    if (mapUrl == null) {
      return const _MapFallback(
        message: 'Peta unsur hara belum tersedia.',
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(fullScreen ? 22 : 16),
      child: Container(
        color: const Color(0xFFF8F8F6),
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          boundaryMargin: const EdgeInsets.all(80),
          child: Center(
            child: Image.network(
              mapUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;

                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3E806D),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _MapFallback(
                  message: 'Gagal memuat peta dari server.\nURL: $mapUrl',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MapFallback extends StatelessWidget {
  final String message;

  const _MapFallback({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F8F6),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          height: 1.4,
          color: Color(0xFF666666),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}