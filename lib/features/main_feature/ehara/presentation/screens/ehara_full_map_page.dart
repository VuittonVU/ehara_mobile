import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../../shared_analysis/widgets/analysis_top_bar.dart';
import '../../models/ehara_model.dart';
import '../widgets/ehara_local_spread_map.dart';

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
                    padding: EdgeInsets.fromLTRB(
                      isSmall ? 12 : 16,
                      isSmall ? 12 : 16,
                      isSmall ? 12 : 16,
                      isSmall ? 12 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isSmall ? 24 : 28),
                      border: Border.all(
                        color: const Color(0xFFD7D7D7),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const EHaraLocalSpreadMap(
                      fullScreen: true,
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