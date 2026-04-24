import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../shared_analysis/widgets/analysis_top_bar.dart';
import '../../models/ganoderma_model.dart';
import '../widgets/ganoderma_interactive_map.dart';

class GanodermaFullMapPage extends StatelessWidget {
  final GanodermaModel data;

  const GanodermaFullMapPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AnalysisTopBar(
                title: 'Peta Ganoderma',
                onBackTap: () => context.pop(),
                onPdfTap: () {},
              ),
              SizedBox(height: isSmall ? 12 : 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isSmall ? 14 : 20,
                    0,
                    isSmall ? 14 : 20,
                    isSmall ? 14 : 20,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isSmall ? 24 : 28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSmall ? 10 : 14),
                      child: GanodermaInteractiveMap(
                        points: data.points,
                        showLegend: true,
                        showControls: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}