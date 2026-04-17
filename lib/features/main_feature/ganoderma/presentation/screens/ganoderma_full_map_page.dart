import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../shared/widgets/analysis_top_bar.dart';
import '../widgets/ganoderma_interactive_map.dart';

class GanodermaFullMapPage extends StatelessWidget {
  const GanodermaFullMapPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: GanodermaInteractiveMap(
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