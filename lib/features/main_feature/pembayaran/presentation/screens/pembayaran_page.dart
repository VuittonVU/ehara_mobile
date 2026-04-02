import 'package:flutter/material.dart';
import '../../../../../core/widgets/app_background.dart';

class PembayaranPage extends StatelessWidget {
  const PembayaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOGO
                Image.asset(
                  'assets/images/logo/logo_ehara.png',
                  width: 78,
                ),

                const SizedBox(height: 24),

                // TITLE
                const Text(
                  'Pembayaran',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3E3E3E),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Fitur pembayaran akan segera tersedia.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B6B6B),
                  ),
                ),

                const SizedBox(height: 40),

                // PLACEHOLDER CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFC9C9C9),
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/cart.png',
                        width: 48,
                        height: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum ada transaksi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3E3E3E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Silakan lakukan pembayaran setelah analisis selesai.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}