import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/screening_provider.dart';

class VaccinationForm extends StatelessWidget {
  const VaccinationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScreeningProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vaccination Information',
          style: AppTextStyles.heading1.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Are you vaccinated against COVID-19?',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        _VaccinationOption(
          label: 'Yes, I am vaccinated',
          icon: Icons.check_circle_outline,
          selected: provider.isVaccinated == true,
          onTap: () => provider.setVaccinated(true),
          selectedColor: AppColors.successGreen,
        ),
        const SizedBox(height: AppSpacing.sm),
        _VaccinationOption(
          label: 'No, I am not vaccinated',
          icon: Icons.cancel_outlined,
          selected: provider.isVaccinated == false,
          onTap: () => provider.setVaccinated(false),
          selectedColor: AppColors.urgentRed,
        ),

        if (provider.isVaccinated == true) ...[
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: AppColors.deepSlate.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: AppColors.primaryBlue.withValues(alpha: 0.6),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Upload Vaccination Certificate',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepSlate,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Optional — upload a photo of your vaccination certificate.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: File picker integration
                      provider.setCertificatePath('mock_certificate.pdf');
                    },
                    icon: const Icon(Icons.attach_file, size: 18),
                    label: Text(
                      provider.certificateFilePath != null
                          ? 'Certificate Attached'
                          : 'Choose File',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _VaccinationOption extends StatelessWidget {
  const _VaccinationOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: selected
                ? selectedColor
                : AppColors.deepSlate.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? selectedColor : AppColors.textMuted, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.deepSlate,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: selectedColor, size: 20),
          ],
        ),
      ),
    );
  }
}
