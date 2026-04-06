import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_status_dialog.dart';
import '../../providers/form_provider.dart';
import '../widgets/form_dropdown_field.dart';
import '../widgets/form_label.dart';
import '../widgets/form_section_card.dart';
import '../widgets/form_stepper.dart';
import '../widgets/form_text_field.dart';

class Form3Page extends StatefulWidget {
  const Form3Page({super.key});

  @override
  State<Form3Page> createState() => _Form3PageState();
}

class _Form3PageState extends State<Form3Page> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  final TextEditingController proyeksiController = TextEditingController();

  final TextEditingController nController = TextEditingController();
  final TextEditingController pController = TextEditingController();
  final TextEditingController kController = TextEditingController();
  final TextEditingController caController = TextEditingController();
  final TextEditingController mgController = TextEditingController();

  bool _hasBoundListeners = false;

  final List<String> bandOptions = const ['Red', 'Green', 'NIR'];
  final List<String> yesNoOptions = const ['Ya', 'Tidak'];
  final List<String> soilOptions = const [
    'Ada Nilai Hara Tanah',
    'Tidak Ada Nilai Hara Tanah',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FormProvider>();
      _fillControllersFromProvider(provider);
      _bindControllerListeners();
      _syncCoordinateControllers(provider);
    });
  }

  void _fillControllersFromProvider(FormProvider provider) {
    idController.text = provider.idTitik;
    proyeksiController.text = provider.proyeksiProtasStep3;

    nController.text = provider.nilaiNStep3;
    pController.text = provider.nilaiPStep3;
    kController.text = provider.nilaiKStep3;
    caController.text = provider.nilaiCaStep3;
    mgController.text = provider.nilaiMgStep3;
  }

  void _syncCoordinateControllers(FormProvider provider) {
    final nextX = provider.longitude?.toStringAsFixed(6) ?? '';
    final nextY = provider.latitude?.toStringAsFixed(6) ?? '';

    if (xController.text != nextX) {
      xController.text = nextX;
    }
    if (yController.text != nextY) {
      yController.text = nextY;
    }
  }

  void _bindControllerListeners() {
    if (_hasBoundListeners) return;
    _hasBoundListeners = true;

    idController.addListener(() {
      context.read<FormProvider>().setIdTitik(idController.text);
    });

    proyeksiController.addListener(() {
      context
          .read<FormProvider>()
          .setProyeksiProtasStep3(proyeksiController.text);
    });

    nController.addListener(() {
      context.read<FormProvider>().setNilaiNStep3(nController.text);
    });

    pController.addListener(() {
      context.read<FormProvider>().setNilaiPStep3(pController.text);
    });

    kController.addListener(() {
      context.read<FormProvider>().setNilaiKStep3(kController.text);
    });

    caController.addListener(() {
      context.read<FormProvider>().setNilaiCaStep3(caController.text);
    });

    mgController.addListener(() {
      context.read<FormProvider>().setNilaiMgStep3(mgController.text);
    });
  }

  @override
  void dispose() {
    idController.dispose();
    xController.dispose();
    yController.dispose();
    proyeksiController.dispose();
    nController.dispose();
    pController.dispose();
    kController.dispose();
    caController.dispose();
    mgController.dispose();
    super.dispose();
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

  Widget _buildSectionTitle(
      String title, {
        String? subtitle,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3A3A3A),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      height: 1,
      color: const Color(0xFFD9D9D9),
    );
  }

  void _showFailedDialog() {
    AppStatusDialog.show(
      context: context,
      title: 'Data Gagal Disimpan!',
      message: 'Mohon lengkapi data yang wajib diisi terlebih dahulu.',
      imagePath: 'assets/maskot/maskot3.png',
      buttonText: 'Coba Ulang',
      onPressed: () => Navigator.pop(context),
    );
  }

  void _showSuccessDialog() {
    AppStatusDialog.show(
      context: context,
      title: 'Data Berhasil Disimpan!',
      message: 'Data analisis hara sudah berhasil disimpan.',
      imagePath: 'assets/maskot/maskot2.png',
      buttonText: 'OK',
      onPressed: () async {
        Navigator.pop(context);
        await context.read<FormProvider>().resetAndClearDraft();
        if (!mounted) return;
        context.go(AppRoutes.dashboard);
      },
    );
  }

  Future<void> _submitForm() async {
    final provider = context.read<FormProvider>();

    if (!provider.validateStep3()) {
      _showFailedDialog();
      return;
    }

    final payload = provider.buildSubmissionPayload();
    debugPrint('FORM SUBMISSION PAYLOAD: $payload');

    await provider.clearDraft();

    if (!mounted) return;
    _showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FormProvider>();
    _syncCoordinateControllers(provider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormStepper(currentStep: 3),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Column(
                    children: [
                      FormSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FormLabel(text: 'ID'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: idController,
                              hintText: 'ID',
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'X'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: xController,
                              hintText: 'Easting',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'Y'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: yController,
                              hintText: 'Northing',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'BAND Red (Merah)'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value:
                              provider.bandRed.isEmpty ? null : provider.bandRed,
                              hintText: 'Red',
                              items: bandOptions
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<FormProvider>().setBandRed(value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'BAND Green (Hijau)'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: provider.bandGreen.isEmpty
                                  ? null
                                  : provider.bandGreen,
                              hintText: 'Green',
                              items: bandOptions
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
                                      .setBandGreen(value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'BAND NIR (Inframerah)'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value:
                              provider.bandNir.isEmpty ? null : provider.bandNir,
                              hintText: 'NIR',
                              items: bandOptions
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<FormProvider>().setBandNir(value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'Proyeksi Protas'),
                            const SizedBox(height: 8),
                            FormTextField(
                              controller: proyeksiController,
                              hintText: 'Proyeksi Protas',
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(
                              text: 'Tambahkan Analisis Deteksi Ganoderma?',
                            ),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: provider.ganodermaStep3.isEmpty
                                  ? null
                                  : provider.ganodermaStep3,
                              hintText: 'Ya',
                              items: yesNoOptions
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
                                      .setGanodermaStep3(value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FormSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              'Input Data Tanah',
                              subtitle:
                              'Silahkan isi data hara tanah untuk hasil yang lebih akurat',
                            ),
                            FormDropdownField<String>(
                              value: provider.statusHaraTanahStep3.isEmpty
                                  ? null
                                  : provider.statusHaraTanahStep3,
                              hintText: 'Ada Nilai Hara Tanah',
                              items: soilOptions
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
                                      .setStatusHaraTanahStep3(value);
                                }
                              },
                            ),
                            _buildDivider(),

                            if (provider.showSoilFieldsStep3) ...[
                              const FormLabel(text: 'Nilai Hara Tanah (N)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: nController,
                                hintText: 'Nilai Hara Tanah (N)',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),

                              const FormLabel(text: 'Nilai Hara Tanah (P)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: pController,
                                hintText: 'Nilai Hara Tanah (P)',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),

                              const FormLabel(text: 'Nilai Hara Tanah (K)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: kController,
                                hintText: 'Nilai Hara Tanah (K)',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),

                              const FormLabel(text: 'Nilai Hara Tanah (Ca)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: caController,
                                hintText: 'Nilai Hara Tanah (Ca)',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),

                              const FormLabel(text: 'Nilai Hara Tanah (Mg)'),
                              const SizedBox(height: 8),
                              FormTextField(
                                controller: mgController,
                                hintText: 'Nilai Hara Tanah (Mg)',
                                keyboardType: TextInputType.number,
                              ),
                            ] else ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFD3D3D3),
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

                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3E7F69),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Simpan Data',
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