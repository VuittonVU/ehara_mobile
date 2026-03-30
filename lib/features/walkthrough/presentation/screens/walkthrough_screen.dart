import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';
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
    if (currentIndex < walkthroughData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
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

            // BUTTON
            WalkthroughButton(
              text: currentIndex == 0 ? "Mulai Sekarang" : "Berikutnya",
              onTap: nextPage,
            ),

            const SizedBox(height: 16),

            // INDICATOR
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