import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../shared/widgets/analysis_primary_button.dart';
import '../../../shared/widgets/analysis_section_card.dart';
import 'ganoderma_interactive_map.dart';

class GanodermaMapSection extends StatelessWidget {
  const GanodermaMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnalysisSectionCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: SizedBox(
            width: double.infinity,
            height: 360,
            child: const GanodermaInteractiveMap(
              showLegend: true,
              showControls: true,
            ),
          ),
        ),
        const SizedBox(height: 18),
        AnalysisPrimaryButton(
          label: 'Lihat Peta',
          onTap: () => context.push(AppRoutes.ganodermaFullMap),
        ),
      ],
    );
  }
}