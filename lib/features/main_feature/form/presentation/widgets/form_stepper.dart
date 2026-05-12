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

  Widget _buildConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
        required Alignment alignment,
        required TextAlign textAlign,
      }) {
    return SizedBox(
      height: 34,
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          textAlign: textAlign,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.5,
            height: 1.2,
            color: isActive
                ? const Color(0xFF555555)
                : const Color(0xFF9A9A9A),
            fontWeight:
            isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
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
            _buildConnector(currentStep >= 2),
            _buildStepCircle(2),
            _buildConnector(currentStep >= 3),
            _buildStepCircle(3),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildLabel(
                'Upload\nFile',
                isActive: currentStep >= 1,
                alignment: Alignment.centerLeft,
                textAlign: TextAlign.left,
              ),
            ),

            Expanded(
              child: _buildLabel(
                'Mapping\nKolom',
                isActive: currentStep >= 2,
                alignment: Alignment.center,
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: _buildLabel(
                'Validasi &\nSimpan Hasil',
                isActive: currentStep >= 3,
                alignment: Alignment.centerRight,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}