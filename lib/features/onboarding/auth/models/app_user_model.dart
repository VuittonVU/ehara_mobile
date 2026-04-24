class AppUserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? username;
  final Map<String, dynamic> raw;

  const AppUserModel({
    this.id,
    this.name,
    this.email,
    this.username,
    required this.raw,
  });

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id']?.toString() ??
          map['user_id']?.toString() ??
          map['uid']?.toString(),
      name: map['name']?.toString() ??
          map['nama']?.toString() ??
          map['nama_lengkap']?.toString(),
      email: map['email']?.toString(),
      username: map['username']?.toString(),
      raw: Map<String, dynamic>.from(map),
    );
  }
}