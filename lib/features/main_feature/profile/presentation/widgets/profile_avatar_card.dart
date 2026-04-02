import 'package:flutter/material.dart';
import '../../models/profile_model.dart';

class ProfileAvatarCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onAvatarTap;

  const ProfileAvatarCard({
    super.key,
    required this.profile,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: 154,
            height: 154,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF7F7F7),
              border: Border.all(
                color: const Color(0xFFD8D8D8),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                ? ClipOval(
              child: Image.network(
                profile.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Center(
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 70,
                      color: Color(0xFF555555),
                    ),
                  );
                },
              ),
            )
                : const Center(
              child: Icon(
                Icons.person_outline_rounded,
                size: 70,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF3D3D3D),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          spacing: 6,
          children: [
            Text(
              profile.email,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF3D3D3D),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (profile.isEmailVerified)
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF3D8B73),
                size: 18,
              ),
            if (profile.isEmailInvalid)
              const Icon(
                Icons.cancel_outlined,
                color: Color(0xFFFF5B5B),
                size: 18,
              ),
          ],
        ),
      ],
    );
  }
}