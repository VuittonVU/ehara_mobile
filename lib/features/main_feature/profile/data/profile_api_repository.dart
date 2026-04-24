import '../../../onboarding/auth/services/auth_service.dart';
import '../models/profile_model.dart';

class ProfileApiRepository {
  final AuthService authService;

  ProfileApiRepository({
    required this.authService,
  });

  Future<ProfileModel> getProfile() async {
    final user = await authService.getProfile();

    print('=== USER FROM AUTH SERVICE: ${user?.raw} ===');

    if (user == null) {
      throw Exception('User tidak ditemukan');
    }

    final raw = user.raw;

    final profile = ProfileModel(
      id: user.id,
      name: user.name ?? '-',
      username: raw['username']?.toString() ?? '-',
      email: user.email ?? '-',
      address: raw['address']?.toString() ?? '',
      phoneNumber: raw['handphone_no']?.toString() ?? '',
      whatsappNumber: raw['whatsapp_no']?.toString() ?? '',
      role: raw['role']?.toString() ?? '',
      status: raw['status']?.toString() ?? '',
      photoUrl: raw['profile_photo_path']?.toString(),
      photoPath: null,
      isEmailVerified: raw['email_verified_at'] != null,
      isEmailInvalid: false,
    );

    print(
      '=== PROFILE MODEL: ${profile.name} | ${profile.email} | ${profile.username} ===',
    );

    return profile;
  }
}