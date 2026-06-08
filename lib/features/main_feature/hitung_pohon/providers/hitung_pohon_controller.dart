import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hitung_pohon_job_model.dart';
import '../services/hitung_pohon_service.dart';
import 'hitung_pohon_state.dart';

final hitungPohonServiceProvider = Provider<HitungPohonService>((ref) {
  return HitungPohonService();
});

final hitungPohonControllerProvider =
StateNotifierProvider<HitungPohonController, HitungPohonState>((ref) {
  return HitungPohonController(ref.read(hitungPohonServiceProvider));
});

class HitungPohonController extends StateNotifier<HitungPohonState> {
  HitungPohonController(this._service) : super(HitungPohonState.initial());

  final HitungPohonService _service;

  static const Duration _pageLoadingTimeout = Duration(seconds: 25);

  static const String _serverErrorMessage =
      'Fitur Hitung Pohon belum dapat dimuat saat ini.\nSilakan coba beberapa saat lagi.';

  static const String _timeoutPageMessage =
      'Fitur Hitung Pohon membutuhkan waktu terlalu lama untuk memuat data.\nServer sedang bermasalah, silakan coba lagi beberapa saat lagi.';

  static const String _timeoutProcessingMessage =
      'Proses hitung pohon sedang berjalan.\nSilakan cek kembali melalui Riwayat Hitung Pohon beberapa saat lagi.';

  String _messageFromError(Object error) {
    if (error is TimeoutException) return _timeoutPageMessage;
    return _serverErrorMessage;
  }

  Future<void> checkBackendConnection() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _service.checkConnection().timeout(_pageLoadingTimeout);
      if (!mounted) return;
      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: _messageFromError(e),
      );
    }
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final history = await _service.getHistory().timeout(_pageLoadingTimeout);
      if (!mounted) return;
      state = state.copyWith(isLoading: false, history: history, clearError: true);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: _messageFromError(e),
      );
    }
  }

  Future<HitungPohonJobModel?> loadJob(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final job = await _service.getJob(id).timeout(_pageLoadingTimeout);
      if (!mounted) return null;
      state = state.copyWith(isLoading: false, currentJob: job, clearError: true);
      return job;
    } catch (e) {
      if (!mounted) return null;
      state = state.copyWith(
        isLoading: false,
        errorMessage: _messageFromError(e),
      );
      return null;
    }
  }

  Future<HitungPohonJobModel?> uploadAndWait(File file) async {
    state = state.copyWith(
      isUploading: true,
      clearError: true,
      clearCurrentJob: true,
    );

    try {
      var job = await _service.uploadTif(file).timeout(_pageLoadingTimeout);
      if (!mounted) return null;
      state = state.copyWith(currentJob: job);

      for (var i = 0; i < 3; i++) {
        if (!job.isProcessing) break;

        await Future.delayed(const Duration(seconds: 2));

        job = await _service.getJob(job.id).timeout(_pageLoadingTimeout);
        if (!mounted) return null;
        state = state.copyWith(currentJob: job);
      }

      List<HitungPohonJobModel> history = state.history;
      try {
        history = await _service.getHistory().timeout(_pageLoadingTimeout);
      } catch (_) {
        // Riwayat tidak wajib berhasil setelah upload. Jangan biarkan ini bikin loading lagi.
      }

      if (job.isProcessing) {
        state = state.copyWith(
          isUploading: false,
          currentJob: job,
          history: history,
          errorMessage: _timeoutProcessingMessage,
        );
        return null;
      }

      state = state.copyWith(
        isUploading: false,
        currentJob: job,
        history: history,
        clearError: true,
      );

      return job;
    } catch (e) {
      if (!mounted) return null;
      state = state.copyWith(
        isUploading: false,
        errorMessage: _messageFromError(e),
      );
      return null;
    }
  }
}
