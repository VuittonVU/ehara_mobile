import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/pressable_button.dart';
import '../../providers/profile_controller.dart';
import '../../providers/profile_state.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/profile_avatar_card.dart';
import '../widgets/profile_menu_tile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _onDetailProfileTap(BuildContext context) {
    context.push(AppRoutes.detailProfil);
  }

  void _onChangePasswordTap(BuildContext context) {
    context.push(AppRoutes.changePassword);
  }

  void _onNotificationTap(BuildContext context) {
    context.push(AppRoutes.notifikasiSettings);
  }

  void _onAboutTap(BuildContext context) {
    context.push(AppRoutes.aboutApp);
  }

  void _onLogoutTap(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF3D8B73),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Konfirmasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E3E3E),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 1.2,
                  color: const Color(0xFF4A4A4A),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Apakah Anda Yakin\nIngin Keluar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E3E3E),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _LogoutDialogButton(
                        label: 'Ya',
                        backgroundColor: const Color(0xFFE95B59),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LogoutDialogButton(
                        label: 'Tidak',
                        backgroundColor: const Color(0xFF3D8B73),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final profile = state.profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(profileControllerProvider.notifier).refreshProfile(),
            child: Builder(
              builder: (context) {
                if (state.isLoading && profile == null) {
                  return const _ProfileLoadingView();
                }

                if (state.viewState == ProfileViewState.error &&
                    profile == null) {
                  return _ProfileErrorView(
                    onRetry: () =>
                        ref.read(profileControllerProvider.notifier).loadProfile(),
                  );
                }

                if (profile == null) {
                  return _ProfileErrorView(
                    onRetry: () =>
                        ref.read(profileControllerProvider.notifier).loadProfile(),
                  );
                }

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Image.asset(
                                'assets/images/logo/logo_ehara.png',
                                width: 78,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ProfileAvatarCard(
                              profile: profile,
                              onAvatarTap: () {},
                            ),
                            const SizedBox(height: 24),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/profile.png',
                              title: 'Detail Profil',
                              onTap: () => _onDetailProfileTap(context),
                            ),
                            const SizedBox(height: 12),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/lock.png',
                              title: 'Ganti Password',
                              onTap: () => _onChangePasswordTap(context),
                            ),
                            const SizedBox(height: 12),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/notification.png',
                              title: 'Notifikasi',
                              onTap: () => _onNotificationTap(context),
                            ),
                            const SizedBox(height: 12),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/info.png',
                              title: 'Tentang Aplikasi',
                              onTap: () => _onAboutTap(context),
                            ),
                            const SizedBox(height: 14),
                            ProfileActionButton(
                              label: 'Keluar',
                              iconPath: 'assets/icons/logout.png',
                              onTap: () => _onLogoutTap(context),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileLoadingView extends StatelessWidget {
  const _ProfileLoadingView();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'assets/images/logo/logo_ehara.png',
              width: 78,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 28),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class _LogoutDialogButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _LogoutDialogButton({
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: PressableButton(
        onTap: onTap,
        enableHaptic: true,
        pressedScale: 0.96,
        pressedTranslateY: 1.5,
        idleTranslateY: -0.5,
        borderRadius: BorderRadius.circular(6),
        color: backgroundColor,
        padding: EdgeInsets.zero,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _ProfileErrorView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          Image.asset(
            'assets/images/logo/logo_ehara.png',
            height: 64,
          ),
          const SizedBox(height: 18),
          const Text(
            'Gagal memuat data profil',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}