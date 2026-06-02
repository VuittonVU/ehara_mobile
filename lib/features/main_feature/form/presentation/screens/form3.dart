import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_status_dialog.dart';
import '../../providers/form_provider.dart';
import '../../providers/form_state.dart';
import '../widgets/form_dropdown_field.dart';
import '../widgets/form_label.dart';
import '../widgets/form_section_card.dart';
import '../widgets/form_stepper.dart';
import '../widgets/form_text_field.dart';

class Form3Page extends ConsumerStatefulWidget {
  const Form3Page({super.key});

  @override
  ConsumerState<Form3Page> createState() => _Form3PageState();
}

class _Form3PageState extends ConsumerState<Form3Page> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  final TextEditingController proyeksiController = TextEditingController();

  bool _hasBoundListeners = false;

  final List<String> bandOptions = const ['Red', 'Green', 'NIR'];
  final List<String> yesNoOptions = const ['Ya', 'Tidak'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(formNotifierProvider.notifier).initialize();

      if (!mounted) return;
      _fillControllersFromState(ref.read(formNotifierProvider));
      _bindControllerListeners();
      _syncCoordinateControllers(ref.read(formNotifierProvider));
    });
  }

  void _fillControllersFromState(TambahFormState state) {
    idController.text = state.idTitik;
    proyeksiController.text = state.proyeksiProtasStep3;
  }

  void _syncCoordinateControllers(TambahFormState state) {
    final nextX = state.longitude?.toStringAsFixed(6) ?? '';
    final nextY = state.latitude?.toStringAsFixed(6) ?? '';

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
      ref.read(formNotifierProvider.notifier).setIdTitik(idController.text);
    });

    proyeksiController.addListener(() {
      ref
          .read(formNotifierProvider.notifier)
          .setProyeksiProtasStep3(proyeksiController.text);
    });
  }

  @override
  void dispose() {
    idController.dispose();
    xController.dispose();
    yController.dispose();
    proyeksiController.dispose();
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
      message: 'Data analisis hara berhasil disimpan ke server.',
      imagePath: 'assets/maskot/maskot2.png',
      buttonText: 'OK',
      onPressed: () async {
        Navigator.pop(context);
        await ref.read(formNotifierProvider.notifier).resetAndClearDraft();
        if (!mounted) return;
        context.go(AppRoutes.dashboard);
      },
    );
  }

  Future<void> _submitForm() async {
    final notifier = ref.read(formNotifierProvider.notifier);

    final validationMessage = notifier.validateStep3Message();
    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      return;
    }

    try {
      await notifier.submitTambahAnalisis();

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(formNotifierProvider);
    _syncCoordinateControllers(formState);

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
                  child: FormSectionCard(
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
                          value: formState.bandRed.isEmpty
                              ? null
                              : formState.bandRed,
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
                              ref
                                  .read(formNotifierProvider.notifier)
                                  .setBandRed(value);
                            }
                          },
                        ),

                        const SizedBox(height: 16),
                        const FormLabel(text: 'BAND Green (Hijau)'),
                        const SizedBox(height: 8),
                        FormDropdownField<String>(
                          value: formState.bandGreen.isEmpty
                              ? null
                              : formState.bandGreen,
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
                              ref
                                  .read(formNotifierProvider.notifier)
                                  .setBandGreen(value);
                            }
                          },
                        ),

                        const SizedBox(height: 16),
                        const FormLabel(text: 'BAND NIR (Inframerah)'),
                        const SizedBox(height: 8),
                        FormDropdownField<String>(
                          value: formState.bandNir.isEmpty
                              ? null
                              : formState.bandNir,
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
                              ref
                                  .read(formNotifierProvider.notifier)
                                  .setBandNir(value);
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
                          value: formState.ganodermaStep3.isEmpty
                              ? null
                              : formState.ganodermaStep3,
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
                              ref
                                  .read(formNotifierProvider.notifier)
                                  .setGanodermaStep3(value);
                            }
                          },
                        ),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: formState.isSavingDraft ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3E7F69),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              formState.isSavingDraft ? 'Menyimpan...' : 'Simpan Data',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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