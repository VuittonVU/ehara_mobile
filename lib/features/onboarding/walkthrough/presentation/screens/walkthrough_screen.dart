import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../data/walkthrough_data.dart';
import '../widgets/walkthrough_page.dart';
import '../widgets/walkthrough_indicator.dart';
import '../widgets/walkthrough_button.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void nextPage() {
    final isLastPage = currentIndex == walkthroughData.length - 1;

    if (isLastPage) {
      context.go(AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentIndex == walkthroughData.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: walkthroughData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return WalkthroughPage(
                    data: walkthroughData[index],
                  );
                },
              ),
            ),

            WalkthroughButton(
              text: isLastPage ? "Masuk Sekarang" : "Berikutnya",
              onTap: nextPage,
            ),

            const SizedBox(height: 16),

            WalkthroughIndicator(
              currentIndex: currentIndex,
              total: walkthroughData.length,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}