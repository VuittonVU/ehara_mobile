import 'package:flutter/material.dart';

import '../../../shared_analysis/widgets/analysis_section_card.dart';

class GanodermaSummarySection extends StatelessWidget {
  const GanodermaSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return AnalysisSectionCard(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 12 : 16,
        isSmall ? 14 : 18,
        isSmall ? 12 : 16,
        isSmall ? 14 : 18,
      ),
      child: Column(
        children: [
          Text(
            'Ringkasan Ganoderma',
            style: TextStyle(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF373737),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            height: 1.1,
            color: const Color(0xFFC9C9C9),
          ),
          SizedBox(height: isSmall ? 14 : 18),
          Row(
            children: const [
              Expanded(
                child: _SummaryCard(
                  color: Color(0xFFE53935),
                  label: 'Terdeteksi',
                  value: '18',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  color: Color(0xFF1DB954),
                  label: 'Tidak Terdeteksi',
                  value: '268',
                ),
              ),
            ],
          ),
          SizedBox(height: isSmall ? 12 : 14),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              isSmall ? 12 : 14,
              isSmall ? 10 : 12,
              isSmall ? 12 : 14,
              isSmall ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE1E1E1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Keterangan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF444444),
                  ),
                ),
                SizedBox(height: 8),
                _LegendRow(
                  color: Color(0xFFE53935),
                  label: 'Ganoderma Terdeteksi',
                ),
                SizedBox(height: 6),
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
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 8 : 12,
        isSmall ? 10 : 12,
        isSmall ? 8 : 12,
        isSmall ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isSmall ? 20 : 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isSmall ? 4 : 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.15,
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
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Row(
      children: [
        Container(
          width: isSmall ? 10 : 12,
          height: isSmall ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: isSmall ? 6 : 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF555555),
            ),
          ),
        ),
      ],
    );
  }
}