class WilayahItem {
  final String code;
  final String name;

  const WilayahItem({
    required this.code,
    required this.name,
  });

  factory WilayahItem.fromJson(Map<String, dynamic> json) {
    final code = (json['kode_prop'] ??
        json['kode_kab'] ??
        json['kode_kec'] ??
        json['kd_wil'] ??
        json['kode'] ??
        json['id'] ??
        '')
        .toString();

    final name = (json['nama_prop'] ??
        json['nama_kab'] ??
        json['nama_kec'] ??
        json['nm_wil'] ??
        json['nama'] ??
        json['name'] ??
        '')
        .toString();

    return WilayahItem(
      code: code,
      name: name,
    );
  }

  @override
  String toString() => name;
}