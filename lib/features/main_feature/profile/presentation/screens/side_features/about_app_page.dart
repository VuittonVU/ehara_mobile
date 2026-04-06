import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widgets/app_background.dart';
import '../../../../../../app/routes/app_routes.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.75;
    size = size.clamp(80.0, 150.0);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: Image.asset(
                          'assets/icons/arrow_back.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                    const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          width: size,
                          height: size,
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
                        const SizedBox(height: 28),
                        _AboutButton(
                          label: 'Syarat & Ketentuan',
                          onTap: () => context.push(AppRoutes.termsPlaceholder),
                        ),
                        const SizedBox(height: 14),
                        _AboutButton(
                          label: 'Kebijakan Privasi',
                          onTap: () => context.push(AppRoutes.privacyPlaceholder),
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

class _AboutButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AboutButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 42,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFC9C9C9),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
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