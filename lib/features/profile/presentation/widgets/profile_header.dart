import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final Profile profile;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
        vertical: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightAccent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _initials(profile.fullName),
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.fullName,
            style: AppTextStyles.heading1.copyWith(
              fontSize: 20,
              color: AppColors.deepSlate,
            ),
          ),
          const SizedBox(height: 4),
          if (profile.phone != null)
            Text(
              profile.phone!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}
