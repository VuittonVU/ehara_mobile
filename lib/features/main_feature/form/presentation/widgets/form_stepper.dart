import 'package:flutter/material.dart';

class FormStepper extends StatelessWidget {
  final int currentStep;

  const FormStepper({
    super.key,
    required this.currentStep,
  });

  static const Color _activeColor = Color(0xFF3E7F69);
  static const Color _inactiveColor = Color(0xFFDCE8E3);
  static const Color _inactiveTextColor = Color(0xFF9AA7A1);
  static const Color _labelColor = Color(0xFF6B6B6B);

  bool _isCompleted(int step) => currentStep > step;
  bool _isCurrent(int step) => currentStep == step;
  bool _isActive(int step) => currentStep >= step;

  Widget _buildStepCircle(int step) {
    final bool isActive = _isActive(step);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? _activeColor : _inactiveColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$step',
        style: TextStyle(
          color: isActive ? Colors.white : _inactiveTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? _activeColor : _inactiveColor,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _buildLabel(
      String text, {
        required bool isActive,
      }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.visible,
      style: TextStyle(
        fontSize: 10.5,
        height: 1.25,
        color: isActive ? const Color(0xFF555555) : const Color(0xFF9A9A9A),
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildStepCircle(1),
            _buildLine(currentStep >= 2),
            _buildStepCircle(2),
            _buildLine(currentStep >= 3),
            _buildStepCircle(3),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildLabel(
                'Form 1: Upload File',
                isActive: currentStep >= 1,
              ),
            ),
            Expanded(
              child: _buildLabel(
                'Data dan Rekomendasi Pupuk',
                isActive: currentStep >= 2,
              ),
            ),
            Expanded(
              child: _buildLabel(
                'Validasi dan Simpan Hasil',
                isActive: currentStep >= 3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}