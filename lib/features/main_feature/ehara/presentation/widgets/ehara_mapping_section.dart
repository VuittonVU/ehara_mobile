import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../models/ehara_model.dart';
import '../../../shared_analysis/widgets/analysis_primary_button.dart';
import '../../../shared_analysis/widgets/analysis_section_card.dart';
import 'ehara_local_spread_map.dart';

class EHaraMappingSection extends StatelessWidget {
  final EHaraModel dashboard;

  const EHaraMappingSection({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Column(
      children: [
        AnalysisSectionCard(
          padding: EdgeInsets.fromLTRB(
            isSmall ? 10 : 14,
            isSmall ? 10 : 14,
            isSmall ? 10 : 14,
            isSmall ? 10 : 14,
          ),
          child: AspectRatio(
            aspectRatio: 1.02,
            child: const EHaraLocalSpreadMap(
              fullScreen: false,
            ),
          ),
        ),
        SizedBox(height: isSmall ? 14 : 18),
        AnalysisPrimaryButton(
          label: 'Lihat Peta',
          onTap: () => context.push(
            AppRoutes.eharaFullMap,
            extra: dashboard,
          ),
        ),
      ],
    );
  }
}