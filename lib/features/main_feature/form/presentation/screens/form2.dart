import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../providers/form_provider.dart';
import '../../providers/form_state.dart';
import '../widgets/form_dropdown_field.dart';
import '../widgets/form_label.dart';
import '../widgets/form_section_card.dart';
import '../widgets/form_stepper.dart';
import '../widgets/form_text_field.dart';

class Form2Page extends ConsumerStatefulWidget {
  const Form2Page({super.key});

  @override
  ConsumerState<Form2Page> createState() => _Form2PageState();
}

class _Form2PageState extends ConsumerState<Form2Page> {
  final TextEditingController _tahunTanamController = TextEditingController();
  final TextEditingController _nomorKcdController = TextEditingController();
  final TextEditingController _blokController = TextEditingController();
  final TextEditingController _luasHaController = TextEditingController();
  final TextEditingController _jumlahPohonHaController =
  TextEditingController();
  final TextEditingController _protasController = TextEditingController();
  final TextEditingController _proyeksiProtasController =
  TextEditingController();

  final TextEditingController _nilaiNController = TextEditingController();
  final TextEditingController _nilaiPController = TextEditingController();
  final TextEditingController _nilaiKController = TextEditingController();
  final TextEditingController _nilaiCaController = TextEditingController();
  final TextEditingController _nilaiMgController = TextEditingController();

  bool _hasBoundListeners = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(formNotifierProvider.notifier).initialize();

      if (!mounted) return;
      _fillControllersFromState(ref.read(formNotifierProvider));
      _bindControllerListeners();
    });
  }

  void _fillControllersFromState(TambahFormState state) {
    _tahunTanamController.text = state.tahunTanam;
    _nomorKcdController.text = state.nomorKcd;
    _blokController.text = state.blok;
    _luasHaController.text = state.luasHa;
    _jumlahPohonHaController.text = state.jumlahPohonHa;
    _protasController.text = state.protas;
    _proyeksiProtasController.text = state.proyeksiProtasStep2;

    _nilaiNController.text = state.nilaiNStep2;
    _nilaiPController.text = state.nilaiPStep2;
    _nilaiKController.text = state.nilaiKStep2;
    _nilaiCaController.text = state.nilaiCaStep2;
    _nilaiMgController.text = state.nilaiMgStep2;
  }

  void _bindControllerListeners() {
    if (_hasBoundListeners) return;
    _hasBoundListeners = true;

    _tahunTanamController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setTahunTanam(_tahunTanamController.text);
    });
    _nomorKcdController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setNomorKcd(_nomorKcdController.text);
    });
    _blokController.addListener(() {
      ref.read(formNotifierProvider.notifier).setBlok(_blokController.text);
    });
    _luasHaController.addListener(() {
      ref.read(formNotifierProvider.notifier).setLuasHa(_luasHaController.text);
    });
    _jumlahPohonHaController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setJumlahPohonHa(_jumlahPohonHaController.text);
    });
    _protasController.addListener(() {
      ref.read(formNotifierProvider.notifier).setProtas(_protasController.text);
    });
    _proyeksiProtasController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setProyeksiProtasStep2(_proyeksiProtasController.text);
    });

    _nilaiNController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setNilaiNStep2(_nilaiNController.text);
    });
    _nilaiPController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setNilaiPStep2(_nilaiPController.text);
    });
    _nilaiKController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setNilaiKStep2(_nilaiKController.text);
    });
    _nilaiCaController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setNilaiCaStep2(_nilaiCaController.text);
    });
    _nilaiMgController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setNilaiMgStep2(_nilaiMgController.text);
    });
  }

  @override
  void dispose() {
    _tahunTanamController.dispose();
    _nomorKcdController.dispose();
    _blokController.dispose();
    _luasHaController.dispose();
    _jumlahPohonHaController.dispose();
    _protasController.dispose();
    _proyeksiProtasController.dispose();

    _nilaiNController.dispose();
    _nilaiPController.dispose();
    _nilaiKController.dispose();
    _nilaiCaController.dispose();
    _nilaiMgController.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    final notifier = ref.read(formNotifierProvider.notifier);

    if (!notifier.validateStep2()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi dulu data Form 2 ya')),
      );
      return;
    }

    if (!mounted) return;
    context.push(AppRoutes.form3Map);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(formNotifierProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    children: [
                      const FormStepper(currentStep: 2),
                      const SizedBox(height: 18),
                      FormSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FormLabel(text: 'Tahun Tanam'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _tahunTanamController,
                              hintText: 'Tahun Tanam',
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(text: 'Nomor KCD'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _nomorKcdController,
                              hintText: 'Nomor KCD',
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(text: 'Blok'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _blokController,
                              hintText: 'Blok',
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(text: 'Luas / Ha'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _luasHaController,
                              hintText: 'Luas / Ha',
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(text: 'Jumlah Pohon / Ha'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _jumlahPohonHaController,
                              hintText: 'Jumlah Pohon / Ha',
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(text: 'Protas'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _protasController,
                              hintText: 'Protas',
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(text: 'Proyeksi Protas'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: _proyeksiProtasController,
                              hintText: 'Proyeksi Protas',
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(
                              text: 'Tambahkan Analisis Deteksi Ganoderma?',
                            ),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: formState.ganodermaStep2,
                              hintText: 'Pilih',
                              items: const ['Ya', 'Tidak']
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  ref
                                      .read(formNotifierProvider.notifier)
                                      .setGanodermaStep2(value);
                                }
                              },
                            ),
                            const SizedBox(height: 18),
                            const FormLabel(text: 'Status Hara Tanah'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: formState.statusHaraTanahStep2,
                              hintText: 'Pilih',
                              items: const [
                                'Ada Nilai Hara Tanah',
                                'Tidak Ada Nilai Hara Tanah',
                              ]
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  ref
                                      .read(formNotifierProvider.notifier)
                                      .setStatusHaraTanahStep2(value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: const Color(0xFFD5D5D5),
                            ),
                            const SizedBox(height: 16),
                            if (formState.showSoilFieldsStep2) ...[
                              const FormLabel(text: 'Nilai Hara Tanah (N)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: _nilaiNController,
                                hintText: 'Nilai Hara Tanah (N)',
                              ),
                              const SizedBox(height: 18),
                              const FormLabel(text: 'Nilai Hara Tanah (P)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: _nilaiPController,
                                hintText: 'Nilai Hara Tanah (P)',
                              ),
                              const SizedBox(height: 18),
                              const FormLabel(text: 'Nilai Hara Tanah (K)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: _nilaiKController,
                                hintText: 'Nilai Hara Tanah (K)',
                              ),
                              const SizedBox(height: 18),
                              const FormLabel(text: 'Nilai Hara Tanah (Ca)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: _nilaiCaController,
                                hintText: 'Nilai Hara Tanah (Ca)',
                              ),
                              const SizedBox(height: 18),
                              const FormLabel(text: 'Nilai Hara Tanah (Mg)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: _nilaiMgController,
                                hintText: 'Nilai Hara Tanah (Mg)',
                              ),
                            ] else ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFCFCFCF),
                                    width: 1.2,
                                  ),
                                ),
                                child: const Text(
                                  'Input nilai hara tanah dilewati.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF777777),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () => context.pop(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFFD9D9D9),
                                        foregroundColor:
                                        const Color(0xFF555555),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Kembali',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: _goNext,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFF2F7D69),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
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
                                ),
                              ],
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