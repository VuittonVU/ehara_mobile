import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../shared_analysis/widgets/analysis_primary_button.dart';
import '../../../shared_analysis/widgets/analysis_section_card.dart';
import 'ganoderma_interactive_map.dart';

class GanodermaMapSection extends StatelessWidget {
  const GanodermaMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mapHeight = MediaQuery.of(context).size.width * 0.86;
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Column(
      children: [
        AnalysisSectionCard(
          padding: EdgeInsets.fromLTRB(
            isSmall ? 10 : 12,
            isSmall ? 10 : 12,
            isSmall ? 10 : 12,
            isSmall ? 10 : 12,
          ),
          child: SizedBox(
            width: double.infinity,
            height: mapHeight,
            child: const GanodermaInteractiveMap(
              showLegend: true,
              showControls: true,
            ),
          ),
        ),
        SizedBox(height: isSmall ? 14 : 18),
        AnalysisPrimaryButton(
          label: 'Lihat Peta',
          onTap: () => context.push(AppRoutes.ganodermaFullMap),
        ),
      ],
    );
  }
}