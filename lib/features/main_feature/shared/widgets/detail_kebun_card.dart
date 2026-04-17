import 'package:flutter/material.dart';

import 'analysis_section_card.dart';

class DetailKebunCard extends StatelessWidget {
  final List<Widget> children;

  const DetailKebunCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AnalysisSectionCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        children: [
          const Text(
            'Detail Kebun',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF373737),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class DetailKebunTwoColumnRow extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;
  final double valueFontSize;

  const DetailKebunTwoColumnRow({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
    this.valueFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final hasRight =
        rightLabel.trim().isNotEmpty || rightValue.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _CompactField(
            label: leftLabel,
            value: leftValue,
            valueFontSize: valueFontSize,
            crossAxisAlignment: CrossAxisAlignment.start,
            textAlign: TextAlign.left,
          ),
        ),
        if (hasRight) ...[
          const SizedBox(width: 14),
          Expanded(
            child: _CompactField(
              label: rightLabel,
              value: rightValue,
              valueFontSize: valueFontSize,
              crossAxisAlignment: CrossAxisAlignment.end,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ],
    );
  }
}

class _CompactField extends StatelessWidget {
  final String label;
  final String value;
  final double valueFontSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign textAlign;

  const _CompactField({
    required this.label,
    required this.value,
    required this.valueFontSize,
    required this.crossAxisAlignment,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A7A7A),
            height: 1.05,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF333333),
            height: 1.05,
          ),
        ),
      ],
    );
  }
}