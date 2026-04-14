import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'detail_profile_state.dart';
import '../../profile_controller.dart';

final detailProfileControllerProvider =
StateNotifierProvider.autoDispose<DetailProfileController, DetailProfileState>(
      (ref) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;

    return DetailProfileController(
      DetailProfileState(
        fullName: profile?.name ?? 'Vuitton Varian Utomo',
        username: 'VVU',
        address: 'Jalan Muktar Basri Komplek Gaharu\nTown House Blok F1B',
        email: profile?.email ?? 'vuittonvarianu@gmail.com',
        phoneNumber: '0895622924083',
        whatsappNumber: '0895622924083',
        isSaving: false,
      ),
    );
  },
);

class DetailProfileController extends StateNotifier<DetailProfileState> {
  DetailProfileController(super.state);

  void updateFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void updateUsername(String value) {
    state = state.copyWith(username: value);
  }

  void updateAddress(String value) {
    state = state.copyWith(address: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void updateWhatsappNumber(String value) {
    state = state.copyWith(whatsappNumber: value);
  }

  Future<void> saveChanges() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isSaving: false);
  }
}