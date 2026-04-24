import 'dart:convert';
import 'dart:typed_data';

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

  // WAJIB disesuaikan sekali dengan path public server map kamu.
  // Contoh final bisa jadi:
  // https://ehara.iopri.co.id/storage/maps/
  // atau
  // https://ehara.iopri.co.id/uploads/maps/
  static const String _mapBaseUrl = 'https://ehara.iopri.co.id/storage/';

  String? _resolveMapUrl() {
    if (dashboard.mapUrl.trim().isNotEmpty) {
      return dashboard.mapUrl.trim();
    }

    if (dashboard.mapFilename.trim().isNotEmpty) {
      return '$_mapBaseUrl${Uri.encodeComponent(dashboard.mapFilename.trim())}';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final mapUrl = _resolveMapUrl();

    if (mapUrl == null || mapUrl.isEmpty) {
      return _MapFallback(
        message: dashboard.mapFilename.isNotEmpty
            ? 'Map filename ada, tapi URL public map belum disesuaikan.\nFilename: ${dashboard.mapFilename}'
            : 'Map sebaran belum tersedia dari backend.',
        fullScreen: fullScreen,
      );
    }

    final borderRadius = BorderRadius.circular(fullScreen ? 20 : 14);

    final image = ClipRRect(
      borderRadius: borderRadius,
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        child: Image.network(
          mapUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _MapFallback(
              message:
              'Gagal memuat map backend.\nCek path public file map di server.\nURL: $mapUrl',
              fullScreen: fullScreen,
            );
          },
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: image,
    );
  }
}

class _MapFallback extends StatelessWidget {
  final String message;
  final bool fullScreen;

  const _MapFallback({
    required this.message,
    required this.fullScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fullScreen ? 16 : 13,
          color: const Color(0xFF666666),
          height: 1.4,
        ),
      ),
    );
  }
}