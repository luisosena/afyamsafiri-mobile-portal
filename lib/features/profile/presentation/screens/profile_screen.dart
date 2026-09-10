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
      context.read<ProfileProvider>().loadProfile();
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
              context.go('/login');
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
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Profile',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 20,
            color: AppColors.deepSlate,
          ),
        ),
        actions: [
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
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(ProfileProvider provider) {
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
                      email: data['email'],
                      phone: data['phone'],
                      nationality: data['nationality'],
                      passportNumber: data['passportNumber'],
                    );
                    if (success && mounted) {
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
