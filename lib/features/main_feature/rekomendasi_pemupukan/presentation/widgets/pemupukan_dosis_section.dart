import 'package:flutter/material.dart';

import '../../../shared/widgets/analysis_section_card.dart';

class PemupukanDoseItem {
  final String title;
  final String minimum;
  final String maksimum;

  const PemupukanDoseItem({
    required this.title,
    required this.minimum,
    required this.maksimum,
  });
}

class PemupukanDosisSection extends StatelessWidget {
  final String title;
  final List<PemupukanDoseItem> items;

  const PemupukanDosisSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return AnalysisSectionCard(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
          Wrap(
            spacing: 22,
            runSpacing: 22,
            alignment: WrapAlignment.center,
            children: items.map((item) {
              return SizedBox(
                width: 110,
                child: Column(
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF373737),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F816D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Minimum',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            item.minimum,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            '|',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 0.9,
                            ),
                          ),
                          Text(
                            item.maksimum,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Maksimum',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}