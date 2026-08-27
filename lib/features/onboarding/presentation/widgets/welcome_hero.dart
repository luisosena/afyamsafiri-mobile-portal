import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/atoms/primary_button.dart';
import '../../../../shared/widgets/atoms/secondary_button.dart';
import '../widgets/security_badge.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Language toggle
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'EN',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const Spacer(flex: 2),

        // Shield / logo icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.lightAccent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: const Icon(
            Icons.health_and_safety_outlined,
            size: 40,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Title
        Text(
          'AfyaMsafiri',
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.deepSlate,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Tagline
        Text(
          'Tanzania Traveller Health\nScreening & Arrival Registration',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Trust microcopy
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lightAccent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_outlined, size: 16, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'Official Service of the United Republic of Tanzania',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Value props
        _ValueProp(
          icon: Icons.flight_takeoff,
          text: 'Register your arrival before you travel',
        ),
        const SizedBox(height: AppSpacing.sm),
        _ValueProp(
          icon: Icons.health_and_safety_outlined,
          text: 'Complete health screening online',
        ),
        const SizedBox(height: AppSpacing.sm),
        _ValueProp(
          icon: Icons.qr_code_2,
          text: 'Get a QR pass for faster border clearance',
        ),

        const Spacer(flex: 2),

        // CTAs
        PrimaryButton(
          label: 'Create Account',
          onPressed: () => context.go('/create-account'),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Log In',
          onPressed: () => context.go('/login'),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Security badges
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SecurityBadge(label: 'End-to-End Encrypted'),
            SizedBox(width: 16),
            SecurityBadge(label: 'Secured by Gov.tz'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _ValueProp extends StatelessWidget {
  const _ValueProp({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.lightAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                color: AppColors.deepSlate,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}