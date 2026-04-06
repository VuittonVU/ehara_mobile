import 'package:flutter/material.dart';

import '../data/profile_placeholder_repository.dart';
import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfilePlaceholderRepository _repository;

  ProfileProvider({
    ProfilePlaceholderRepository? repository,
  }) : _repository = repository ?? ProfilePlaceholderRepository();

  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.getProfile();
    } catch (e) {
      _errorMessage = 'Gagal memuat data profil';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}