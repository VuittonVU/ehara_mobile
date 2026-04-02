import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/routes/app_routes.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../data/profile_placeholder_repository.dart';
import '../../models/profile_model.dart';

import '../widgets/profile_action_button.dart';
import '../widgets/profile_avatar_card.dart';
import '../widgets/profile_menu_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfilePlaceholderRepository _repository =
  ProfilePlaceholderRepository();

  late Future<ProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _repository.getProfile();
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _profileFuture = _repository.getProfile();
    });
  }

  void _onDetailProfileTap() {
    debugPrint('Go to Detail Page');
    context.push(AppRoutes.detailProfil);
  }

  void _onChangePasswordTap() {
    debugPrint('Go to Change Password');
    context.push(AppRoutes.changePassword);
  }

  void _onNotificationTap() {
    debugPrint('Go to Notification Settings');
    context.push(AppRoutes.notifikasiSettings);
  }

  void _onAboutTap() {
    debugPrint('Go to About App');
    context.push(AppRoutes.aboutApp);
  }

  void _onLogoutTap() {
    _showLogoutConfirmationDialog();
  }

  void _confirmLogout() {
    debugPrint('Perform logout');
  }

  void _showLogoutConfirmationDialog() {
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
                          _confirmLogout();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AppBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshProfile,
            child: FutureBuilder<ProfileModel>(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _ProfileLoadingView();
                }

                if (snapshot.hasError) {
                  return _ProfileErrorView(
                    onRetry: _refreshProfile,
                  );
                }

                final profile = snapshot.data ?? ProfileModel.placeholder();

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                              onAvatarTap: () {
                                debugPrint('Change avatar');
                              },
                            ),
                            const SizedBox(height: 24),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/profile.png',
                              title: 'Detail Profil',
                              onTap: _onDetailProfileTap,
                            ),
                            const SizedBox(height: 12),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/lock.png',
                              title: 'Ganti Password',
                              onTap: _onChangePasswordTap,
                            ),
                            const SizedBox(height: 12),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/notification.png',
                              title: 'Notifikasi',
                              onTap: _onNotificationTap,
                            ),
                            const SizedBox(height: 12),
                            ProfileMenuTile(
                              iconPath: 'assets/icons/info.png',
                              title: 'Tentang Aplikasi',
                              onTap: _onAboutTap,
                            ),
                            const SizedBox(height: 14),
                            ProfileActionButton(
                              label: 'Keluar',
                              iconPath: 'assets/icons/logout.png',
                              onTap: _onLogoutTap,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
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