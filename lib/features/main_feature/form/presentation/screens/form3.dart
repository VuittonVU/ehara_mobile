import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../widgets/form_dropdown_field.dart';
import '../widgets/form_label.dart';
import '../widgets/form_section_card.dart';
import '../widgets/form_stepper.dart';
import '../widgets/form_text_field.dart';

class Form3Page extends StatefulWidget {
  final double selectedLatitude;
  final double selectedLongitude;

  const Form3Page({
    super.key,
    required this.selectedLatitude,
    required this.selectedLongitude,
  });

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

  String? selectedBandRed;
  String? selectedBandGreen;
  String? selectedBandNir;
  String? selectedGanoderma;
  String? selectedHasSoilData;

  final List<String> bandOptions = const ['Red', 'Green', 'NIR'];
  final List<String> yesNoOptions = const ['Ya', 'Tidak'];

  @override
  void initState() {
    super.initState();
    xController.text = widget.selectedLongitude.toStringAsFixed(6);
    yController.text = widget.selectedLatitude.toStringAsFixed(6);
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
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
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/ehara_robot_failed.png',
                        height: 170,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.smart_toy_rounded,
                          size: 120,
                          color: Color(0xFF3E7F69),
                        ),
                      ),
                    ),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFF4D4F),
                          width: 4,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFFF4D4F),
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Data Gagal Disimpan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: 190,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E7F69),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Coba Ulang',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
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
                Center(
                  child: Image.asset(
                    'assets/images/ehara_robot_success.png',
                    height: 170,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.smart_toy_rounded,
                      size: 120,
                      color: Color(0xFF3E7F69),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Data Berhasil Disimpan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF6B10A),
                            foregroundColor: const Color(0xFF333333),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Nanti Saja',
                            style: TextStyle(fontWeight: FontWeight.w700),
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
                            backgroundColor: const Color(0xFF3E7F69),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Lanjut Ke Pembayaran',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
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

  void _submitForm() {
    if (idController.text.trim().isEmpty ||
        xController.text.trim().isEmpty ||
        yController.text.trim().isEmpty ||
        selectedBandRed == null ||
        selectedBandGreen == null ||
        selectedBandNir == null ||
        proyeksiController.text.trim().isEmpty ||
        selectedGanoderma == null) {
      _showFailedDialog();
      return;
    }

    _showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
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
                              value: selectedBandRed,
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
                                setState(() {
                                  selectedBandRed = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'BAND Green (Hijau)'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: selectedBandGreen,
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
                                setState(() {
                                  selectedBandGreen = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            const FormLabel(text: 'BAND NIR (Inframerah)'),
                            const SizedBox(height: 8),
                            FormDropdownField<String>(
                              value: selectedBandNir,
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
                                setState(() {
                                  selectedBandNir = value;
                                });
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
                              value: selectedGanoderma,
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
                                setState(() {
                                  selectedGanoderma = value;
                                });
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
                              value: selectedHasSoilData,
                              hintText: 'Ada Nilai Hara Tanah',
                              items: yesNoOptions
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedHasSoilData = value;
                                });
                              },
                            ),
                            _buildDivider(),

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
                            const SizedBox(height: 24),

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
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFF3E7F69),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Lanjutkan',
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