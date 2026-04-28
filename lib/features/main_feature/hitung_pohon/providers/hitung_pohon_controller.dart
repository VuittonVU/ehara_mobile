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

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final history = await _service.getHistory();
      state = state.copyWith(isLoading: false, history: history);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<HitungPohonJobModel?> loadJob(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final job = await _service.getJob(id);
      state = state.copyWith(isLoading: false, currentJob: job);
      return job;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }

  Future<HitungPohonJobModel?> uploadAndWait(File file) async {
    state = state.copyWith(isUploading: true, clearError: true, clearCurrentJob: true);

    try {
      var job = await _service.uploadTif(file);
      state = state.copyWith(currentJob: job);

      for (var i = 0; i < 60; i++) {
        if (!job.isProcessing) break;
        await Future.delayed(const Duration(seconds: 2));
        job = await _service.getJob(job.id);
        state = state.copyWith(currentJob: job);
      }

      final history = await _service.getHistory();
      state = state.copyWith(
        isUploading: false,
        currentJob: job,
        history: history,
      );
      return job;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }
}
