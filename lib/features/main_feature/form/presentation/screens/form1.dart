import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../data/sensor_options.dart';
import '../../models/wilayah_item.dart';
import '../../providers/form_provider.dart';
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
  final TextEditingController _namaPerusahaanController =
  TextEditingController();
  final TextEditingController _namaKebunController = TextEditingController();
  final TextEditingController _detailLokasiController = TextEditingController();
  final TextEditingController _tanggalPengambilanController =
  TextEditingController();
  final TextEditingController _tanggalAnalisisController =
  TextEditingController();

  bool _hasBoundListeners = false;
  bool _hasCheckedDraftDialog = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<FormProvider>();

      _fillControllersFromProvider(provider);
      _bindControllerListeners();

      if (!_hasCheckedDraftDialog && provider.hasDraft) {
        _hasCheckedDraftDialog = true;

        final shouldLoad = await showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Lanjutkan Draft?'),
              content: const Text(
                'Ditemukan draft form sebelumnya. Mau lanjutkan?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Tidak'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ya'),
                ),
              ],
            );
          },
        );

        if (!mounted) return;

        if (shouldLoad == true) {
          await provider.loadDraft();
          if (!mounted) return;
          _fillControllersFromProvider(provider);
        }
      }
    });
  }

  void _bindControllerListeners() {
    if (_hasBoundListeners) return;
    _hasBoundListeners = true;

    _namaProjekController.addListener(() {
      context.read<FormProvider>().setNamaProjek(_namaProjekController.text);
    });

    _namaPerusahaanController.addListener(() {
      context
          .read<FormProvider>()
          .setNamaPerusahaan(_namaPerusahaanController.text);
    });

    _namaKebunController.addListener(() {
      context.read<FormProvider>().setNamaKebun(_namaKebunController.text);
    });

    _detailLokasiController.addListener(() {
      context.read<FormProvider>().setDetailLokasi(_detailLokasiController.text);
    });

    _tanggalPengambilanController.addListener(() {
      context
          .read<FormProvider>()
          .setTanggalPengambilan(_tanggalPengambilanController.text);
    });

    _tanggalAnalisisController.addListener(() {
      context
          .read<FormProvider>()
          .setTanggalAnalisis(_tanggalAnalisisController.text);
    });
  }

  void _fillControllersFromProvider(FormProvider provider) {
    _namaProjekController.text = provider.namaProjek;
    _namaPerusahaanController.text = provider.namaPerusahaan;
    _namaKebunController.text = provider.namaKebun;
    _detailLokasiController.text = provider.detailLokasi;
    _tanggalPengambilanController.text = provider.tanggalPengambilan;
    _tanggalAnalisisController.text = provider.tanggalAnalisis;
  }

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

  Future<void> _goNext() async {
    final provider = context.read<FormProvider>();

    if (!provider.validateStep1()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi dulu data Form 1 ya'),
        ),
      );
      return;
    }

    if (!mounted) return;
    context.push(AppRoutes.form2);
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

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2F2F2F),
          ),
        ),
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
            'Silakan isi data dengan lengkap sebelum lanjut ke tahap berikutnya.',
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FormProvider>();

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
                              title: provider.fileName.isEmpty
                                  ? 'Unggah File Sampel'
                                  : provider.fileName,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Fitur upload file masih placeholder',
                                    ),
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
                            FormDropdownField<WilayahItem>(
                              value: provider.selectedProvinsi,
                              hintText: provider.isLoadingProvinsi
                                  ? 'Memuat provinsi...'
                                  : 'Pilih Provinsi',
                              items: provider.provinsiList
                                  .map(
                                    (item) => DropdownMenuItem<WilayahItem>(
                                  value: item,
                                  child: Text(item.name),
                                ),
                              )
                                  .toList(),
                              onChanged: provider.isLoadingProvinsi
                                  ? null
                                  : (value) {
                                if (value == null) return;
                                context
                                    .read<FormProvider>()
                                    .selectProvinsi(value);
                              },
                            ),
                            const SizedBox(height: 12),

                            const FormLabel(text: 'Kota / Kabupaten'),
                            const SizedBox(height: 8),
                            FormDropdownField<WilayahItem>(
                              value: provider.selectedKabupaten,
                              hintText: provider.isLoadingKabupaten
                                  ? 'Memuat kabupaten...'
                                  : 'Pilih Kota / Kabupaten',
                              items: provider.kabupatenList
                                  .map(
                                    (item) => DropdownMenuItem<WilayahItem>(
                                  value: item,
                                  child: Text(item.name),
                                ),
                              )
                                  .toList(),
                              onChanged: provider.selectedProvinsi == null ||
                                  provider.isLoadingKabupaten
                                  ? null
                                  : (value) {
                                if (value == null) return;
                                context
                                    .read<FormProvider>()
                                    .selectKabupaten(value);
                              },
                            ),
                            const SizedBox(height: 12),

                            const FormLabel(text: 'Kecamatan'),
                            const SizedBox(height: 8),
                            FormDropdownField<WilayahItem>(
                              value: provider.selectedKecamatan,
                              hintText: provider.isLoadingKecamatan
                                  ? 'Memuat kecamatan...'
                                  : 'Pilih Kecamatan',
                              items: provider.kecamatanList
                                  .map(
                                    (item) => DropdownMenuItem<WilayahItem>(
                                  value: item,
                                  child: Text(item.name),
                                ),
                              )
                                  .toList(),
                              onChanged: provider.selectedKabupaten == null ||
                                  provider.isLoadingKecamatan
                                  ? null
                                  : (value) {
                                context
                                    .read<FormProvider>()
                                    .selectKecamatan(value);
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
                              onTap: () =>
                                  _pickDate(_tanggalPengambilanController),
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Color(0xFF444444),
                              ),
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'Tanggal Analisis'),
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

                            const FormLabel(text: 'Sensor'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value:
                              provider.sensor.isEmpty ? null : provider.sensor,
                              hintText: 'Pilih sensor',
                              items: SensorOptions.items
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                context.read<FormProvider>().setSensor(value);
                              },
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(
                              text: 'Tambahkan Analisis Deteksi Ganoderma?',
                            ),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: provider.ganodermaStep1.isEmpty
                                  ? null
                                  : provider.ganodermaStep1,
                              hintText: 'Pilih opsi',
                              items: const ['Ya', 'Tidak']
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                context
                                    .read<FormProvider>()
                                    .setGanodermaStep1(value);
                              },
                            ),

                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _goNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2F7D69),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Selanjutnya',
                                  style: TextStyle(
                                    fontSize: 14,
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