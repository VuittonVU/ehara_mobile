import 'package:flutter/material.dart';

import '../../../../../../core/widgets/app_background.dart';
import '../../widgets/profile_header.dart';

class LegalPlaceholderPage extends StatelessWidget {
  final String title;

  const LegalPlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              ProfileHeader(
                title: title,
                onBackTap: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      'Halaman ini masih placeholder.\nNanti akan diganti menjadi WebView.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF404040),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Copyright © 2026 PPKS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
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