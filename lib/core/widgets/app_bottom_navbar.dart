import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onTapHome;
  final VoidCallback onTapRiwayat;
  final VoidCallback onTapTambahAnalisis;
  final VoidCallback onTapPembayaran;
  final VoidCallback onTapProfile;

  const AppBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTapHome,
    required this.onTapRiwayat,
    required this.onTapTambahAnalisis,
    required this.onTapPembayaran,
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.textPrimary.withOpacity(0.15),
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  iconPath: 'assets/icons/house.png',
                  label: 'Dashboard',
                  isActive: currentIndex == 0,
                  onTap: onTapHome,
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  iconPath: 'assets/icons/riwayat.png',
                  label: 'Riwayat',
                  isActive: currentIndex == 1,
                  onTap: onTapRiwayat,
                ),
              ),

              const SizedBox(width: 76),

              Expanded(
                child: _BottomNavItem(
                  iconPath: 'assets/icons/cart.png',
                  label: 'Pembayaran',
                  isActive: currentIndex == 3,
                  onTap: onTapPembayaran,
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  iconPath: 'assets/icons/circle_user.png',
                  label: 'Profile',
                  isActive: currentIndex == 4,
                  onTap: onTapProfile,
                ),
              ),
            ],
          ),

          Positioned(
            top: -28,
            child: GestureDetector(
              onTap: onTapTambahAnalisis,
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/palm.png',
                        width: 32,
                        height: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 8,
            child: Text(
              'Tambah\nAnalisis',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(
                color: currentIndex == 2
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isActive
        ? const Color(0xFF387867)
        : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: itemColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}