import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/molecules/summary_row.dart';
import '../../domain/entities/profile.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({
    super.key,
    required this.profile,
    this.onEdit,
  });

  final Profile profile;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Personal Information',
                  style: AppTextStyles.inputLabel.copyWith(
                    color: AppColors.deepSlate,
                  ),
                ),
                const Spacer(),
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: Text(
                      'Edit',
                      style: AppTextStyles.inputLabel.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceGray),
          SummaryRow(label: 'Full Name', value: profile.fullName),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.surfaceGray),
          SummaryRow(label: 'Phone', value: profile.phone ?? 'Not provided'),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.surfaceGray),
          SummaryRow(label: 'Nationality', value: profile.nationality ?? 'Not provided'),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.surfaceGray),
          SummaryRow(label: 'Passport Number', value: profile.passportNumber ?? 'Not provided'),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
