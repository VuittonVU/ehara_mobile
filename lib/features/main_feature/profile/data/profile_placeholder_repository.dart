import '../models/profile_model.dart';

class ProfilePlaceholderRepository {
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return ProfileModel.placeholder();
  }
}