class ProfileModel {
  final String name;
  final String email;
  final String? photoUrl;
  final bool isEmailVerified;
  final bool isEmailInvalid;

  const ProfileModel({
    required this.name,
    required this.email,
    this.photoUrl,
    this.isEmailVerified = false,
    this.isEmailInvalid = false,
  });

  ProfileModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    bool? isEmailVerified,
    bool? isEmailInvalid,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isEmailInvalid: isEmailInvalid ?? this.isEmailInvalid,
    );
  }

  factory ProfileModel.placeholder() {
    return const ProfileModel(
      name: 'Vuitton Varian Utomo',
      email: 'vuittonvarianu@gmail.com',
      photoUrl: null,
      isEmailVerified: true,
      isEmailInvalid: true,
    );
  }
}