import 'package:flutter/material.dart';

import '../../../shared/widgets/analysis_section_card.dart';

class GanodermaSummarySection extends StatelessWidget {
  const GanodermaSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalysisSectionCard(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        children: [
          const Text(
            'Ringkasan Ganoderma',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF373737),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 1.1,
            color: const Color(0xFFC9C9C9),
          ),
          const SizedBox(height: 22),
          Row(
            children: const [
              Expanded(
                child: _SummaryCard(
                  color: Color(0xFFE53935),
                  label: 'Terdeteksi',
                  value: '18',
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _SummaryCard(
                  color: Color(0xFF1DB954),
                  label: 'Tidak Terdeteksi',
                  value: '268',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE1E1E1),
                width: 1,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keterangan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF444444),
                  ),
                ),
                SizedBox(height: 10),
                _LegendRow(
                  color: Color(0xFFE53935),
                  label: 'Ganoderma Terdeteksi',
                ),
                SizedBox(height: 8),
                _LegendRow(
                  color: Color(0xFF1DB954),
                  label: 'Tidak Terdeteksi',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _SummaryCard({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
        ),
      ],
    );
  }
}