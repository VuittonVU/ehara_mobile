import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile_controller.dart';
import 'detail_profile_state.dart';

final detailProfileControllerProvider =
StateNotifierProvider.autoDispose<DetailProfileController, DetailProfileState>(
      (ref) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;

    return DetailProfileController(
      ref,
      DetailProfileState(
        fullName: profile?.name ?? '',
        username: profile?.username ?? '',
        address: profile?.address ?? '',
        email: profile?.email ?? '',
        phoneNumber: profile?.phoneNumber ?? '',
        whatsappNumber: profile?.whatsappNumber ?? '',
        isSaving: false,
      ),
    );
  },
);

class DetailProfileController extends StateNotifier<DetailProfileState> {
  DetailProfileController(this._ref, super.state);

  final Ref _ref;

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
    await Future.delayed(const Duration(milliseconds: 350));

    _ref.read(profileControllerProvider.notifier).updateLocalProfile(
      name: state.fullName,
      username: state.username,
      address: state.address,
      email: state.email,
      phoneNumber: state.phoneNumber,
      whatsappNumber: state.whatsappNumber,
    );

    state = state.copyWith(isSaving: false);
  }
}