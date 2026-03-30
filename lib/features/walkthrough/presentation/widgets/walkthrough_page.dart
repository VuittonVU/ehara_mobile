import 'package:flutter/material.dart';
import '../../models/walkthrough_model.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

class WalkthroughPage extends StatelessWidget {
  final WalkthroughModel data;

  const WalkthroughPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // LOGO + SKIP
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LOGO
              Image.asset(
                "assets/images/logo/logo_ehara.png",
                height: 80,
              ),

              // SKIP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Lewati",
                  style: AppTextStyles.medium(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // TITLE
        _buildStyledTitle(data.title),

        const SizedBox(height: 20),

        // IMAGE + CLOUDS
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              /// CLOUD LEFT
              Positioned(
                left: -10,
                bottom: 10,
                child: Image.asset(
                  'assets/images/maskot/cloud.png',
                  width: 160,
                  fit: BoxFit.contain,
                ),
              ),

              /// CLOUD RIGHT (FLIPPED)
              Positioned(
                right: 0,
                bottom: -60,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                  child: Image.asset(
                    'assets/images/maskot/cloud.png',
                    width: 230,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              /// MAIN IMAGE
              Image.asset(
                data.image,
                height: 240,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        const SizedBox(height: 110),

        // TEXT SECTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                data.subtitle,
                style: AppTextStyles.heading1(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildStyledTitle(String title) {
    switch (title) {
      case "EFISIEN":
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "E",
                style: AppTextStyles.displayLarge(
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: "FISIEN",
                style: AppTextStyles.displayLarge(),
              ),
            ],
          ),
        );

      case "HANDAL":
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "HA",
                style: AppTextStyles.displayLarge(
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: "NDAL",
                style: AppTextStyles.displayLarge(),
              ),
            ],
          ),
        );

      case "AKURAT":
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "AKU",
                style: AppTextStyles.displayLarge(),
              ),
              TextSpan(
                text: "RA",
                style: AppTextStyles.displayLarge(
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: "T",
                style: AppTextStyles.displayLarge(),
              ),
            ],
          ),
        );

      default:
        return Text(
          title,
          style: AppTextStyles.displayLarge(),
        );
    }
  }
}