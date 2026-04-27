import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../shared_analysis/widgets/analysis_top_bar.dart';
import '../../models/ehara_model.dart';
import '../widgets/ehara_map_view.dart';

class EHaraFullMapPage extends StatelessWidget {
  final EHaraModel dashboard;

  const EHaraFullMapPage({
    super.key,
    required this.dashboard,
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
                title: 'Peta Sebaran Hara',
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
                    padding: EdgeInsets.all(isSmall ? 10 : 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isSmall ? 26 : 30),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 14,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: EHaraMapView(
                            dashboard: dashboard,
                            fullScreen: true,
                          ),
                        ),
                        Positioned(
                          left: 14,
                          bottom: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x18000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Cubit untuk zoom • geser untuk melihat peta',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3E806D),
                              ),
                            ),
                          ),
                        ),
                      ],
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