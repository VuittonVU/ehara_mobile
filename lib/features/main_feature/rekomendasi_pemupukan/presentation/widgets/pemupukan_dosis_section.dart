import 'package:flutter/material.dart';

import '../../../shared_analysis/widgets/analysis_section_card.dart';

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
    final isSmall = MediaQuery.of(context).size.width < 360;
    final itemWidth = isSmall ? 94.0 : 108.0;
    final boxWidth = isSmall ? 86.0 : 96.0;
    final boxHeight = isSmall ? 108.0 : 116.0;

    return AnalysisSectionCard(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 14 : 18,
        isSmall ? 16 : 20,
        isSmall ? 14 : 18,
        isSmall ? 16 : 20,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF373737),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 1.1,
            color: const Color(0xFFC9C9C9),
          ),
          SizedBox(height: isSmall ? 18 : 22),
          Wrap(
            spacing: isSmall ? 12 : 18,
            runSpacing: isSmall ? 16 : 22,
            alignment: WrapAlignment.center,
            children: items.map((item) {
              return SizedBox(
                width: itemWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF373737),
                      ),
                    ),
                    SizedBox(height: isSmall ? 8 : 10),
                    Container(
                      width: boxWidth,
                      height: boxHeight,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 6 : 8,
                        vertical: isSmall ? 8 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F816D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Minimum',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmall ? 8 : 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmall ? 2 : 3),

                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                item.minimum,
                                style: TextStyle(
                                  fontSize: isSmall ? 14 : 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Text('|',
                              style: TextStyle(
                                fontSize: isSmall ? 14 : 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              )),

                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                item.maksimum,
                                style: TextStyle(
                                  fontSize: isSmall ? 14 : 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmall ? 2 : 3),

                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Maksimum',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmall ? 8 : 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
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