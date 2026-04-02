import 'package:flutter/material.dart';
import '../../../../../../core/widgets/app_background.dart';
import '../../../../../../core/widgets/app_status_dialog.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final TextEditingController _fullNameController =
  TextEditingController(text: 'Vuitton Varian Utomo');
  final TextEditingController _usernameController =
  TextEditingController(text: 'VVU');
  final TextEditingController _addressController = TextEditingController(
    text: 'Jalan Muktar Basri Komplek Gaharu\nTown House Blok F1B',
  );
  final TextEditingController _emailController =
  TextEditingController(text: 'vuittonvarianu@gmail.com');
  final TextEditingController _phoneController =
  TextEditingController(text: '0895622924083');
  final TextEditingController _whatsappController =
  TextEditingController(text: '0895622924083');

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _onSaveChanges() {
    AppStatusDialog.show(
      context: context,
      title: 'Data Berhasil Disimpan!',
      message: 'Perubahan profil kamu sudah berhasil diperbarui.',
      imagePath: 'assets/maskot/maskot2.png',
      buttonText: 'Oke',
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.18),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFF3E7F69),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Konfirmasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1.4,
                  color: const Color(0xFF4A4A4A),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Apakah Anda Yakin\nIngin Menghapus Akun\nAnda?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showDeleteSuccessDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE95B59),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Ya',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A8A74),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Tidak',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteSuccessDialog() {
    AppStatusDialog.show(
      context: context,
      title: 'Akun Berhasil Dihapus!',
      message: 'Akun kamu sudah berhasil dihapus.',
      imagePath: 'assets/maskot/maskot2.png',
      buttonText: 'Kembali ke Halaman Pendaftaran',
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Image.asset(
                        'assets/icons/arrow_back.png',
                        width: 28,
                        height: 30,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Detail Profil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF8F8F8),
                        border: Border.all(
                          color: const Color(0xFFD8D8D8),
                          width: 1.8,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 72,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 14,
                      bottom: 18,
                      child: Image.asset(
                        'assets/icons/edit.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFC9C9C9),
                      width: 1.6,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _ProfileInputField(
                        label: 'Nama Lengkap',
                        hintText: 'Nama Lengkap',
                        controller: _fullNameController,
                        iconPath: 'assets/icons/profile.png',
                      ),
                      const SizedBox(height: 14),
                      _ProfileInputField(
                        label: 'Username',
                        hintText: 'Username',
                        controller: _usernameController,
                        iconPath: 'assets/icons/username.png',
                      ),
                      const SizedBox(height: 14),
                      _ProfileInputField(
                        label: 'Alamat',
                        hintText: 'Alamat',
                        controller: _addressController,
                        iconPath: 'assets/icons/location.png',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 14),
                      _ProfileInputField(
                        label: 'Email',
                        hintText: 'Email',
                        controller: _emailController,
                        iconPath: 'assets/icons/email.png',
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Image.asset(
                            'assets/icons/check.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ProfileInputField(
                        label: 'Nomor Handphone',
                        hintText: 'Nomor Handphone',
                        controller: _phoneController,
                        iconPath: 'assets/icons/phone.png',
                      ),
                      const SizedBox(height: 14),
                      _ProfileInputField(
                        label: 'Nomor Whatsapp',
                        hintText: 'Nomor Whatsapp',
                        controller: _whatsappController,
                        iconPath: 'assets/icons/phone.png',
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _onSaveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A8A74),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton.icon(
                    onPressed: _showDeleteConfirmationDialog,
                    icon: Image.asset(
                      'assets/icons/trash.png',
                      width: 28,
                      height: 28,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Hapus Akun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4B4B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Copyright © 2026 PPKS',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4E4E4E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String iconPath;
  final Widget? suffix;
  final int maxLines;

  const _ProfileInputField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.iconPath,
    this.suffix,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4A4A4A),
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 46,
              minHeight: 46,
            ),
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFFC9C9C9),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF4A8A74),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}