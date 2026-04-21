import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/routes/app_routes.dart';
import '../../../../../../core/widgets/app_background.dart';
import '../../../../../../core/widgets/pressable_button.dart';
import '../../widgets/profile_header.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    double logoSize = MediaQuery.of(context).size.width * 0.75;
    logoSize = logoSize.clamp(80.0, 150.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              ProfileHeader(
                title: 'Tentang Aplikasi',
                onBackTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Aplikasi e-Hara',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF343434),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Versi 1.0.0',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: logoSize,
                          height: logoSize,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              'assets/images/logo/logo_ehara.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return const Center(
                                  child: Text(
                                    'e - HARA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Copyright © 2026 PPKS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3A3A3A),
                          ),
                        ),
                        const SizedBox(height: 34),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              _AboutButton(
                                label: 'Syarat & Ketentuan',
                                onTap: () {
                                  context.push(AppRoutes.termsPlaceholder);
                                },
                              ),
                              const SizedBox(height: 18),
                              _AboutButton(
                                label: 'Kebijakan Privasi',
                                onTap: () {
                                  context.push(AppRoutes.privacyPolicy);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
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

class _AboutButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AboutButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: PressableButton(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            color: const Color(0xFFC9C9C9),
            width: 2,
          ),
          pressedScale: 0.97,
          pressedTranslateY: 1.2,
          idleTranslateY: -0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B3B3B),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}