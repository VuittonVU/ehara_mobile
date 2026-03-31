import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../app/routes/app_routes.dart';

import '../../../../../core/widgets/app_background.dart';
import '../widgets/form_dropdown_field.dart';
import '../widgets/form_label.dart';
import '../widgets/form_section_card.dart';
import '../widgets/form_stepper.dart';
import '../widgets/form_text_field.dart';
import '../widgets/upload_box.dart';

class Form1Page extends StatefulWidget {
  const Form1Page({super.key});

  @override
  State<Form1Page> createState() => _Form1PageState();
}

class _Form1PageState extends State<Form1Page> {
  final TextEditingController _namaProjekController = TextEditingController();
  final TextEditingController _namaPerusahaanController = TextEditingController();
  final TextEditingController _namaKebunController = TextEditingController();
  final TextEditingController _detailLokasiController = TextEditingController();
  final TextEditingController _tanggalPengambilanController = TextEditingController();
  final TextEditingController _tanggalAnalisisController = TextEditingController();

  String? _selectedProvinsi;
  String? _selectedKabupaten;
  String? _selectedKecamatan;
  String? _selectedSensor;
  String? _selectedGanoderma;

  final List<String> _provinsiOptions = const [];
  final List<String> _kabupatenOptions = const [];
  final List<String> _kecamatanOptions = const [];

  final List<String> _sensorOptions = const [
    'MicaSense',
    'Mapir',
    'DJI',
    'Lainnya',
  ];

  final List<String> _ganodermaOptions = const [
    'Ya',
    'Tidak',
  ];

  @override
  void dispose() {
    _namaProjekController.dispose();
    _namaPerusahaanController.dispose();
    _namaKebunController.dispose();
    _detailLokasiController.dispose();
    _tanggalPengambilanController.dispose();
    _tanggalAnalisisController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      final day = pickedDate.day.toString().padLeft(2, '0');
      final month = pickedDate.month.toString().padLeft(2, '0');
      final year = pickedDate.year.toString();
      controller.text = '$day/$month/$year';
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => context.pop(),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Analisis Hara',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFD27A),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catatan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE39B00),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Silakan unggah file sampel untuk proses analisis hara. '
                'Bagian wilayah masih disiapkan, jadi untuk sementara dropdown lokasi '
                'dibiarkan sebagai placeholder terlebih dahulu.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDropdown({
    required String hintText,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return FormDropdownField<String>(
      value: value,
      hintText: hintText,
      items: const [],
      onChanged: onChanged,
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F2F2F),
          ),
        ),
      ),
    );
  }

  void _goNext() {
    context.push(AppRoutes.form2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    children: [
                      const FormStepper(currentStep: 1),
                      const SizedBox(height: 18),
                      FormSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoCard(),

                            _buildSectionTitle('Unggah File'),
                            UploadBox(
                              title: 'Unggah File Sampel',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur upload file masih placeholder'),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Format yang didukung: .xlsx / .xls / .csv',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 24),
                            _buildSectionTitle('Informasi Projek'),

                            const FormLabel(text: 'Nama Projek'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _namaProjekController,
                              hintText: 'Masukkan nama projek',
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'Nama Perusahaan'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _namaPerusahaanController,
                              hintText: 'Masukkan nama perusahaan',
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'Nama Kebun'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _namaKebunController,
                              hintText: 'Masukkan nama kebun',
                            ),

                            const SizedBox(height: 24),
                            _buildSectionTitle('Lokasi Pengambilan Data'),

                            const FormLabel(text: 'Provinsi'),
                            const SizedBox(height: 8),
                            _buildEmptyDropdown(
                              hintText: 'Pilih Provinsi',
                              value: _selectedProvinsi,
                              onChanged: (value) {
                                setState(() {
                                  _selectedProvinsi = value;
                                  _selectedKabupaten = null;
                                  _selectedKecamatan = null;
                                });
                              },
                            ),
                            const SizedBox(height: 12),

                            const FormLabel(text: 'Kota / Kabupaten'),
                            const SizedBox(height: 8),
                            _buildEmptyDropdown(
                              hintText: 'Pilih Kota / Kabupaten',
                              value: _selectedKabupaten,
                              onChanged: (value) {
                                setState(() {
                                  _selectedKabupaten = value;
                                  _selectedKecamatan = null;
                                });
                              },
                            ),
                            const SizedBox(height: 12),

                            const FormLabel(text: 'Kecamatan'),
                            const SizedBox(height: 8),
                            _buildEmptyDropdown(
                              hintText: 'Pilih Kecamatan',
                              value: _selectedKecamatan,
                              onChanged: (value) {
                                setState(() {
                                  _selectedKecamatan = value;
                                });
                              },
                            ),
                            const SizedBox(height: 12),

                            const FormLabel(text: 'Detail Lokasi'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _detailLokasiController,
                              hintText: 'Masukkan detail lokasi',
                            ),

                            const SizedBox(height: 24),
                            _buildSectionTitle('Tanggal dan Sensor'),

                            const FormLabel(text: 'Tanggal Pengambilan Data'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _tanggalPengambilanController,
                              hintText: 'Pilih tanggal',
                              readOnly: true,
                              onTap: () => _pickDate(_tanggalPengambilanController),
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Color(0xFF444444),
                              ),
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'Tanggal Analisis Data'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _tanggalAnalisisController,
                              hintText: 'Pilih tanggal',
                              readOnly: true,
                              onTap: () => _pickDate(_tanggalAnalisisController),
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Color(0xFF444444),
                              ),
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'Jenis Sensor'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: _selectedSensor,
                              hintText: 'Pilih sensor',
                              items: _sensorOptions
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSensor = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(
                              text: 'Tambahkan Analisis Deteksi Ganoderma?',
                            ),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: _selectedGanoderma,
                              hintText: 'Pilih opsi',
                              items: _ganodermaOptions
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGanoderma = value;
                                });
                              },
                            ),

                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _goNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3E7F69),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Lanjut ke Form 2',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}