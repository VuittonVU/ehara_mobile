import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../data/sensor_options.dart';
import '../../models/wilayah_item.dart';
import '../../providers/form_provider.dart';
import '../../providers/form_state.dart';
import '../widgets/form_dropdown_field.dart';
import '../widgets/form_label.dart';
import '../widgets/form_section_card.dart';
import '../widgets/form_stepper.dart';
import '../widgets/form_text_field.dart';
import 'upload_box.dart';

class Form1Page extends ConsumerStatefulWidget {
  const Form1Page({super.key});

  @override
  ConsumerState<Form1Page> createState() => _Form1PageState();
}

class _Form1PageState extends ConsumerState<Form1Page> {
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
      final notifier = ref.read(formNotifierProvider.notifier);
      await notifier.initialize();

      if (!mounted) return;
      _fillControllersFromState(ref.read(formNotifierProvider));
      _bindControllerListeners();

      final currentState = ref.read(formNotifierProvider);
      if (!_hasCheckedDraftDialog && currentState.hasDraft) {
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
          await notifier.loadDraft();
          if (!mounted) return;
          _fillControllersFromState(ref.read(formNotifierProvider));
        }
      }
    });
  }

  void _bindControllerListeners() {
    if (_hasBoundListeners) return;
    _hasBoundListeners = true;

    _namaProjekController.addListener(() {
      ref.read(formNotifierProvider.notifier).setNamaProjek(
        _namaProjekController.text,
      );
    });

    _namaPerusahaanController.addListener(() {
      ref.read(formNotifierProvider.notifier).setNamaPerusahaan(
        _namaPerusahaanController.text,
      );
    });

    _namaKebunController.addListener(() {
      ref.read(formNotifierProvider.notifier).setNamaKebun(
        _namaKebunController.text,
      );
    });

    _detailLokasiController.addListener(() {
      ref.read(formNotifierProvider.notifier).setDetailLokasi(
        _detailLokasiController.text,
      );
    });

    _tanggalPengambilanController.addListener(() {
      ref.read(formNotifierProvider.notifier).setTanggalPengambilan(
        _tanggalPengambilanController.text,
      );
    });

    _tanggalAnalisisController.addListener(() {
      ref.read(formNotifierProvider.notifier).setTanggalAnalisis(
        _tanggalAnalisisController.text,
      );
    });
  }

  void _fillControllersFromState(TambahFormState state) {
    _namaProjekController.text = state.namaProjek;
    _namaPerusahaanController.text = state.namaPerusahaan;
    _namaKebunController.text = state.namaKebun;
    _detailLokasiController.text = state.detailLokasi;
    _tanggalPengambilanController.text = state.tanggalPengambilan;
    _tanggalAnalisisController.text = state.tanggalAnalisis;
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

  Future<void> _pickTemporaryImage() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      if (!mounted) return;

      ref.read(formNotifierProvider.notifier).setTemporaryImage(
        bytes: bytes,
        imageName: picked.name,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gambar dipilih sementara'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih gambar'),
        ),
      );
    }
  }

  Future<void> _goNext() async {
    final notifier = ref.read(formNotifierProvider.notifier);

    if (!notifier.validateStep1()) {
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
    final formState = ref.watch(formNotifierProvider);

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
                              title: formState.temporaryImageBytes != null
                                  ? 'Preview Gambar'
                                  : 'Unggah Gambar Sampel',
                              subtitle: formState.temporaryImageBytes != null
                                  ? formState.temporaryImageName
                                  : 'Placeholder sementara, tidak disimpan permanen',
                              imageBytes: formState.temporaryImageBytes,
                              onTap: _pickTemporaryImage,
                              onClear: formState.temporaryImageBytes == null
                                  ? null
                                  : () {
                                ref
                                    .read(formNotifierProvider.notifier)
                                    .clearTemporaryImage();
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Format sementara: gambar dari galeri. Hanya preview lokal.',
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
                              value: formState.selectedProvinsi,
                              hintText: formState.isLoadingProvinsi
                                  ? 'Memuat provinsi...'
                                  : 'Pilih Provinsi',
                              items: formState.provinsiList
                                  .map(
                                    (item) => DropdownMenuItem<WilayahItem>(
                                  value: item,
                                  child: Text(item.name),
                                ),
                              )
                                  .toList(),
                              onChanged: formState.isLoadingProvinsi
                                  ? null
                                  : (value) async {
                                if (value == null) return;
                                await ref
                                    .read(formNotifierProvider.notifier)
                                    .selectProvinsi(value);
                              },
                            ),
                            const SizedBox(height: 12),
                            const FormLabel(text: 'Kota / Kabupaten'),
                            const SizedBox(height: 8),
                            FormDropdownField<WilayahItem>(
                              value: formState.selectedKabupaten,
                              hintText: formState.isLoadingKabupaten
                                  ? 'Memuat kabupaten...'
                                  : 'Pilih Kota / Kabupaten',
                              items: formState.kabupatenList
                                  .map(
                                    (item) => DropdownMenuItem<WilayahItem>(
                                  value: item,
                                  child: Text(item.name),
                                ),
                              )
                                  .toList(),
                              onChanged: formState.selectedProvinsi == null ||
                                  formState.isLoadingKabupaten
                                  ? null
                                  : (value) async {
                                if (value == null) return;
                                await ref
                                    .read(formNotifierProvider.notifier)
                                    .selectKabupaten(value);
                              },
                            ),
                            const SizedBox(height: 12),
                            const FormLabel(text: 'Kecamatan'),
                            const SizedBox(height: 8),
                            FormDropdownField<WilayahItem>(
                              value: formState.selectedKecamatan,
                              hintText: formState.isLoadingKecamatan
                                  ? 'Memuat kecamatan...'
                                  : 'Pilih Kecamatan',
                              items: formState.kecamatanList
                                  .map(
                                    (item) => DropdownMenuItem<WilayahItem>(
                                  value: item,
                                  child: Text(item.name),
                                ),
                              )
                                  .toList(),
                              onChanged: formState.selectedKabupaten == null ||
                                  formState.isLoadingKecamatan
                                  ? null
                                  : (value) {
                                ref
                                    .read(formNotifierProvider.notifier)
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
                              value: formState.sensor.isEmpty
                                  ? null
                                  : formState.sensor,
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
                                ref
                                    .read(formNotifierProvider.notifier)
                                    .setSensor(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            const FormLabel(
                              text: 'Tambahkan Analisis Deteksi Ganoderma?',
                            ),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: formState.ganodermaStep1.isEmpty
                                  ? null
                                  : formState.ganodermaStep1,
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
                                ref
                                    .read(formNotifierProvider.notifier)
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