class DetailProfileState {
  final String fullName;
  final String username;
  final String address;
  final String email;
  final String phoneNumber;
  final String whatsappNumber;
  final bool isSaving;

  const DetailProfileState({
    required this.fullName,
    required this.username,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.isSaving,
  });

  factory DetailProfileState.initial() {
    return const DetailProfileState(
      fullName: '',
      username: '',
      address: '',
      email: '',
      phoneNumber: '',
      whatsappNumber: '',
      isSaving: false,
    );
  }

  DetailProfileState copyWith({
    String? fullName,
    String? username,
    String? address,
    String? email,
    String? phoneNumber,
    String? whatsappNumber,
    bool? isSaving,
  }) {
    return DetailProfileState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      address: address ?? this.address,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}