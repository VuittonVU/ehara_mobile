import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive.dart';
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

    final bool isVerified = profile.isEmailVerified;
    final bool isInvalid = profile.isEmailInvalid;

    final _EmailStatusData status = isVerified
        ? const _EmailStatusData(
      icon: Icons.check_circle_outline_rounded,
      iconColor: Color(0xFF3D8B73),
      text: 'Email terverifikasi',
      textColor: Color(0xFF3D8B73),
    )
        : isInvalid
        ? const _EmailStatusData(
      icon: Icons.cancel_outlined,
      iconColor: Color(0xFFFF5B5B),
      text: 'Email tidak valid',
      textColor: Color(0xFFFF5B5B),
    )
        : const _EmailStatusData(
      icon: Icons.schedule_rounded,
      iconColor: Color(0xFFB78A2A),
      text: 'Menunggu verifikasi email',
      textColor: Color(0xFFB78A2A),
    );

    final avatarSize = Responsive.w(context, 154);
    final iconSize = Responsive.w(context, 70);
    final statusIconSize = Responsive.w(context, 18);

    final hasLocalPhoto =
        profile.photoPath != null && profile.photoPath!.trim().isNotEmpty;
    final hasNetworkPhoto =
        profile.photoUrl != null && profile.photoUrl!.trim().isNotEmpty;

    Widget avatarChild;
    if (hasLocalPhoto) {
      avatarChild = ClipOval(
        child: Image.file(
          File(profile.photoPath!),
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Center(
              child: Icon(
                Icons.person_outline_rounded,
                size: iconSize,
                color: const Color(0xFF555555),
              ),
            );
          },
        ),
      );
    } else if (hasNetworkPhoto) {
      avatarChild = ClipOval(
        child: Image.network(
          profile.photoUrl!,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Center(
              child: Icon(
                Icons.person_outline_rounded,
                size: iconSize,
                color: const Color(0xFF555555),
              ),
            );
          },
        ),
      );
    } else {
      avatarChild = Center(
        child: Icon(
          Icons.person_outline_rounded,
          size: iconSize,
          color: const Color(0xFF555555),
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF7F7F7),
              border: Border.all(
                color: const Color(0xFFD8D8D8),
                width: Responsive.w(context, 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x22000000),
                  blurRadius: Responsive.w(context, 14),
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: avatarChild,
          ),
        ),
        SizedBox(height: Responsive.h(context, 18)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 12),
          ),
          child: Text(
            profile.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3D3D3D),
              fontSize: Responsive.sp(context, 24),
              height: 1.15,
            ),
          ),
        ),
        SizedBox(height: Responsive.h(context, 8)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 18),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            runSpacing: Responsive.h(context, 4),
            spacing: Responsive.w(context, 6),
            children: [
              Text(
                profile.email,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF3D3D3D),
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.sp(context, 14),
                ),
              ),
              Icon(
                status.icon,
                color: status.iconColor,
                size: statusIconSize,
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.h(context, 6)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 20),
          ),
          child: Text(
            status.text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: status.textColor,
              fontWeight: FontWeight.w600,
              fontSize: Responsive.sp(context, 11.5),
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmailStatusData {
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color textColor;

  const _EmailStatusData({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.textColor,
  });
}