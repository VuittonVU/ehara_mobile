class ProfileModel {
  final String? id;
  final String name;
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String whatsappNumber;
  final String role;
  final String status;
  final String? photoUrl;
  final String? photoPath;
  final bool isEmailVerified;
  final bool isEmailInvalid;

  const ProfileModel({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.role,
    required this.status,
    this.photoUrl,
    this.photoPath,
    this.isEmailVerified = false,
    this.isEmailInvalid = false,
  });

  ProfileModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? address,
    String? phoneNumber,
    String? whatsappNumber,
    String? role,
    String? status,
    String? photoUrl,
    String? photoPath,
    bool? isEmailVerified,
    bool? isEmailInvalid,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      photoPath: photoPath ?? this.photoPath,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isEmailInvalid: isEmailInvalid ?? this.isEmailInvalid,
    );
  }

  factory ProfileModel.placeholder() {
    return const ProfileModel(
      id: null,
      name: 'User123',
      username: 'U123',
      email: 'user@gmail.com',
      address:
      'Jl. Brigjend Katamso No.51, Kp. Baru, Kec. Medan Maimun, Kota Medan, Sumatera Utara 20158',
      phoneNumber: '-',
      whatsappNumber: '-',
      role: 'user',
      status: 'active',
      photoUrl: null,
      photoPath: null,
      isEmailVerified: true,
      isEmailInvalid: false,
    );
  }
}