import 'package:flutter/material.dart';

enum AppStateType {
  empty,
  filterEmpty,
  error,
  noConnection,
  backendError,
}

class AppStateView extends StatelessWidget {
  final AppStateType type;
  final String? title;
  final String? description;
  final VoidCallback? onRetry;
  final bool showRetryButton;

  const AppStateView({
    super.key,
    required this.type,
    this.title,
    this.description,
    this.onRetry,
    this.showRetryButton = true,
  });

  factory AppStateView.fromError({
    Key? key,
    String? message,
    VoidCallback? onRetry,
    String? title,
    String? description,
  }) {
    final lowerMessage = (message ?? '').toLowerCase();
    final isConnectionError = lowerMessage.contains('socketexception') ||
        lowerMessage.contains('failed host lookup') ||
        lowerMessage.contains('network is unreachable') ||
        lowerMessage.contains('connection refused') ||
        lowerMessage.contains('connection timed out') ||
        lowerMessage.contains('no address associated') ||
        lowerMessage.contains('internet') ||
        lowerMessage.contains('koneksi');

    return AppStateView(
      key: key,
      type: isConnectionError ? AppStateType.noConnection : AppStateType.backendError,
      title: title,
      description: description,
      onRetry: onRetry,
    );
  }

  String get _title {
    if (title != null) return title!;

    switch (type) {
      case AppStateType.empty:
      case AppStateType.filterEmpty:
      case AppStateType.error:
        return 'Data belum ditemukan!';
      case AppStateType.noConnection:
        return 'Koneksi Terputus!';
      case AppStateType.backendError:
        return 'Server sedang bermasalah!';
    }
  }

  String get _description {
    if (description != null) return description!;

    switch (type) {
      case AppStateType.empty:
        return 'Klik tombol “Tambah Analisis” untuk mulai tambah analisis pertama kamu dan optimalkan hasil panen sekarang!';
      case AppStateType.filterEmpty:
      case AppStateType.error:
        return 'Coba sesuaikan pencarian atau filter anda!';
      case AppStateType.noConnection:
        return 'Perangkatmu sedang tidak terhubung dengan internet!';
      case AppStateType.backendError:
        return 'Data gagal di-fetch dari backend. Server mungkin sedang mati atau belum tersedia.';
    }
  }

  Widget _buildBadge(BuildContext context) {
    switch (type) {
      case AppStateType.noConnection:
        return const Icon(
          Icons.wifi_off_rounded,
          size: 40,
          color: Colors.red,
        );
      case AppStateType.empty:
      case AppStateType.filterEmpty:
      case AppStateType.error:
      case AppStateType.backendError:
        return const Text(
          '? ?',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3E7F69),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width < 360 ? 150.0 : 175.0;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -22,
                  child: _buildBadge(context),
                ),
                Image.asset(
                  'assets/maskot/maskot3.png',
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              _title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.25,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w400,
              ),
            ),
            if (onRetry != null && showRetryButton) ...[
              const SizedBox(height: 18),
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E7F69),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Coba Lagi',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
