import 'package:flutter/material.dart';

import '../../models/ehara_model.dart';
import '../../../shared_analysis/widgets/analysis_section_card.dart';

class EHaraStatusSection extends StatelessWidget {
  final EHaraModel dashboard;

  const EHaraStatusSection({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    final items = [
      _HaraStatusData('N', dashboard.nValue, 0.19, const Color(0xFF4A8A76)),
      _HaraStatusData('P', dashboard.pValue, 1.10, const Color(0xFFD8A441)),
      _HaraStatusData('K', dashboard.kValue, 0.70, const Color(0xFF6FA8DC)),
      _HaraStatusData('Mg', dashboard.mgValue, 0.30, const Color(0xFFB58A2F)),
    ];

    return AnalysisSectionCard(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 14 : 18,
        isSmall ? 18 : 22,
        isSmall ? 14 : 18,
        isSmall ? 18 : 22,
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _StatusRow(data: items[i]),
            if (i != items.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _HaraStatusData {
  final String label;
  final double value;
  final double standard;
  final Color color;

  const _HaraStatusData(
      this.label,
      this.value,
      this.standard,
      this.color,
      );

  double get maxScale {
    final maxValue = value > standard ? value : standard;
    return maxValue <= 0 ? 1 : maxValue * 1.35;
  }

  _HaraLevel get level {
    if (standard <= 0) return _HaraLevel.optimal;

    final ratio = value / standard;
    if (ratio < 0.85) return _HaraLevel.kurang;
    if (ratio > 1.15) return _HaraLevel.berlebih;
    return _HaraLevel.optimal;
  }
}

enum _HaraLevel { kurang, optimal, berlebih }

extension _HaraLevelX on _HaraLevel {
  String get text {
    switch (this) {
      case _HaraLevel.kurang:
        return 'Kurang';
      case _HaraLevel.optimal:
        return 'Optimal';
      case _HaraLevel.berlebih:
        return 'Berlebih';
    }
  }
}

class _StatusRow extends StatelessWidget {
  final _HaraStatusData data;

  const _StatusRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: isSmall ? 46 : 54,
          child: Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: data.label.length > 1 ? 24 : 27,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFB58A2F),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Standar ${data.standard.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF777777),
                    ),
                  ),
                  const Spacer(),
                  _ValueBadge(data: data),
                ],
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final valueX =
                      (data.value / data.maxScale).clamp(0.0, 1.0) * width;

                  return SizedBox(
                    height: 22,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 5,
                          child: Container(
                            height: 13,
                            decoration: BoxDecoration(
                              color: data.color.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 5,
                          child: Container(
                            width: valueX,
                            height: 13,
                            decoration: BoxDecoration(
                              color: data.color,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: data.color.withOpacity(0.25),
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: (valueX - 9).clamp(0.0, width - 18),
                          top: 2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: data.color,
                                width: 2.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: data.color.withOpacity(0.35),
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValueBadge extends StatelessWidget {
  final _HaraStatusData data;

  const _ValueBadge({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${data.value.toStringAsFixed(2)} • ${data.level.text}',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: data.color.darken(),
        ),
      ),
    );
  }
}

extension _ColorDarken on Color {
  Color darken([double amount = .22]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}