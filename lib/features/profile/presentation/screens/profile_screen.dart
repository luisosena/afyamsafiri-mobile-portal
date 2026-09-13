import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_edit_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<ProfileProvider>().loadProfile();
      }
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.urgentRed),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 20,
            color: AppColors.deepSlate,
          ),
        ),

        actions: [
          if (authProvider.isAuthenticated)
            TextButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Sign Out'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.urgentRed,
              ),
            ),
        ],
      ),
      body: authProvider.isAuthenticated
          ? _AuthenticatedProfile()
          : _GuestProfile(),
    );
  }
}

class _GuestProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.lightAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 40,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Guest',
              style: AppTextStyles.heading1.copyWith(
                fontSize: 20,
                color: AppColors.deepSlate,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Sign in to save your profile and sync bookings across devices.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: const Text('Log In'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/create-account'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthenticatedProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    switch (provider.status) {
      case ProfileStatus.initial:
      case ProfileStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        );
      case ProfileStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.urgentRed),
              const SizedBox(height: AppSpacing.md),
              Text(
                provider.errorMessage ?? 'Failed to load profile',
                style: AppTextStyles.body.copyWith(color: AppColors.deepSlate),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => provider.loadProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case ProfileStatus.loaded:
      case ProfileStatus.updating:
        final profile = provider.profile;
        if (profile == null) {
          return const Center(child: Text('No profile data'));
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              ProfileHeader(profile: profile),
              const SizedBox(height: AppSpacing.md),
              if (provider.isEditing)
                ProfileEditForm(
                  profile: profile,
                  isSaving: provider.status == ProfileStatus.updating,
                  onSave: (data) async {
                    final success = await provider.updateProfile(
                      fullName: data['fullName'],
                      phone: data['phone'],
                      nationality: data['nationality'],
                      passportNumber: data['passportNumber'],
                    );
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully.'),
                          backgroundColor: AppColors.successGreen,
                        ),
                      );
                    }
                  },
                  onCancel: () => provider.cancelEditing(),
                )
              else
                ProfileInfoSection(
                  profile: profile,
                  onEdit: () => provider.toggleEditing(),
                ),
              if (provider.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerPadding,
                  ),
                  child: Text(
                    provider.errorMessage!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.urgentRed),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
    }
  }
}