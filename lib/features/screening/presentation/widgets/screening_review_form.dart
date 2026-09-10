import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/molecules/editable_section.dart';
import '../../../../shared/widgets/molecules/summary_row.dart';
import '../providers/screening_provider.dart';

class ScreeningReviewForm extends StatelessWidget {
  const ScreeningReviewForm({super.key, this.onEditStep});

  final ValueChanged<int>? onEditStep;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScreeningProvider>();

    final selectedSymptoms = provider.noneSymptoms
        ? ['None']
        : provider.symptoms
            .where((s) => s.selected)
            .map((s) => s.name)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Health Screening',
          style: AppTextStyles.heading1.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Review your answers before submitting.',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Travel History
        EditableSection(
          title: 'Travel History',
          onEdit: () => onEditStep?.call(0),
          children: [
            SummaryRow(
              label: 'Countries visited',
              value: provider.countries.join(', '),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Symptoms
        EditableSection(
          title: 'Symptoms',
          onEdit: () => onEditStep?.call(1),
          children: [
            SummaryRow(
              label: 'Current symptoms',
              value: selectedSymptoms.join(', '),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Vaccination
        EditableSection(
          title: 'Vaccination',
          onEdit: () => onEditStep?.call(2),
          children: [
            SummaryRow(
              label: 'Vaccinated',
              value: provider.isVaccinated == true ? 'Yes' : 'No',
            ),
            if (provider.certificateFilePath != null)
              SummaryRow(
                label: 'Certificate',
                value: 'Attached',
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Additional Health
        EditableSection(
          title: 'Additional Health',
          onEdit: () => onEditStep?.call(3),
          children: [
            SummaryRow(
              label: 'Contact with infectious disease',
              value: provider.hasContactWithInfectiousDisease == true
                  ? 'Yes'
                  : 'No',
            ),
            SummaryRow(
              label: 'Medical travel purpose',
              value: provider.isMedicalTravelPurpose == true ? 'Yes' : 'No',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Declaration
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Legal Declaration',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSlate,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'I declare that the information provided is true and accurate to the best of my knowledge. I understand that providing false information may have legal consequences.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () => provider
                    .setDeclarationAccepted(!provider.declarationAccepted),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusXs),
                        border: Border.all(
                          color: provider.declarationAccepted
                              ? AppColors.primaryBlue
                              : AppColors.deepSlate.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        color: provider.declarationAccepted
                            ? AppColors.primaryBlue
                            : Colors.transparent,
                      ),
                      child: provider.declarationAccepted
                          ? const Icon(Icons.check, size: 14, color: AppColors.white)
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'I accept the terms and legal declaration',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.deepSlate,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
