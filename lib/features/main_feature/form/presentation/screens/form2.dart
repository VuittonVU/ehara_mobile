import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../providers/form_provider.dart';
import '../widgets/form_dropdown_field.dart';
import '../widgets/form_label.dart';
import '../widgets/form_section_card.dart';
import '../widgets/form_stepper.dart';
import '../widgets/form_text_field.dart';

class Form2Page extends StatefulWidget {
  const Form2Page({super.key});

  @override
  State<Form2Page> createState() => _Form2PageState();
}

class _Form2PageState extends State<Form2Page> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FormProvider>();
      _fillControllersFromProvider(provider);
      _bindControllerListeners();
    });
  }

  void _fillControllersFromProvider(FormProvider provider) {
    _tahunTanamController.text = provider.tahunTanam;
    _nomorKcdController.text = provider.nomorKcd;
    _blokController.text = provider.blok;
    _luasHaController.text = provider.luasHa;
    _jumlahPohonHaController.text = provider.jumlahPohonHa;
    _protasController.text = provider.protas;
    _proyeksiProtasController.text = provider.proyeksiProtasStep2;

    _nilaiNController.text = provider.nilaiNStep2;
    _nilaiPController.text = provider.nilaiPStep2;
    _nilaiKController.text = provider.nilaiKStep2;
    _nilaiCaController.text = provider.nilaiCaStep2;
    _nilaiMgController.text = provider.nilaiMgStep2;
  }

  void _bindControllerListeners() {
    if (_hasBoundListeners) return;
    _hasBoundListeners = true;

    _tahunTanamController.addListener(() {
      context.read<FormProvider>().setTahunTanam(_tahunTanamController.text);
    });
    _nomorKcdController.addListener(() {
      context.read<FormProvider>().setNomorKcd(_nomorKcdController.text);
    });
    _blokController.addListener(() {
      context.read<FormProvider>().setBlok(_blokController.text);
    });
    _luasHaController.addListener(() {
      context.read<FormProvider>().setLuasHa(_luasHaController.text);
    });
    _jumlahPohonHaController.addListener(() {
      context
          .read<FormProvider>()
          .setJumlahPohonHa(_jumlahPohonHaController.text);
    });
    _protasController.addListener(() {
      context.read<FormProvider>().setProtas(_protasController.text);
    });
    _proyeksiProtasController.addListener(() {
      context
          .read<FormProvider>()
          .setProyeksiProtasStep2(_proyeksiProtasController.text);
    });

    _nilaiNController.addListener(() {
      context.read<FormProvider>().setNilaiNStep2(_nilaiNController.text);
    });
    _nilaiPController.addListener(() {
      context.read<FormProvider>().setNilaiPStep2(_nilaiPController.text);
    });
    _nilaiKController.addListener(() {
      context.read<FormProvider>().setNilaiKStep2(_nilaiKController.text);
    });
    _nilaiCaController.addListener(() {
      context.read<FormProvider>().setNilaiCaStep2(_nilaiCaController.text);
    });
    _nilaiMgController.addListener(() {
      context.read<FormProvider>().setNilaiMgStep2(_nilaiMgController.text);
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
    final provider = context.read<FormProvider>();

    if (!provider.validateStep2()) {
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
    final provider = context.watch<FormProvider>();

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
                              value: provider.ganodermaStep2,
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
                                  context
                                      .read<FormProvider>()
                                      .setGanodermaStep2(value);
                                }
                              },
                            ),
                            const SizedBox(height: 18),

                            const FormLabel(text: 'Status Hara Tanah'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: provider.statusHaraTanahStep2,
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
                                  context
                                      .read<FormProvider>()
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

                            if (provider.showSoilFieldsStep2) ...[
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