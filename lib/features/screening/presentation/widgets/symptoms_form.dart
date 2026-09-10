import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/screening_provider.dart';

class SymptomsForm extends StatelessWidget {
  const SymptomsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScreeningProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Symptoms',
          style: AppTextStyles.heading1.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Are you currently experiencing any of the following?',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        ...provider.symptoms.map((symptom) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _SymptomTile(
              label: symptom.name,
              selected: symptom.selected,
              enabled: !provider.noneSymptoms,
              onTap: () => provider.toggleSymptom(symptom.id),
            ),
          );
        }),

        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.deepSlate.withValues(alpha: 0.1),
        ),
        const SizedBox(height: AppSpacing.sm),

        _SymptomTile(
          label: 'None of these',
          selected: provider.noneSymptoms,
          enabled: true,
          onTap: () => provider.setNoneSymptoms(!provider.noneSymptoms),
          isNone: true,
        ),
      ],
    );
  }
}

class _SymptomTile extends StatelessWidget {
  const _SymptomTile({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
    this.isNone = false,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;
  final bool isNone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryBlue.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: selected
                ? AppColors.primaryBlue
                : AppColors.deepSlate.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: isNone ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: isNone
                    ? BorderRadius.circular(AppSpacing.radiusXs)
                    : null,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryBlue
                      : AppColors.deepSlate.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                color: selected ? AppColors.primaryBlue : Colors.transparent,
              ),
              child: selected
                  ? Icon(
                      isNone ? Icons.check : Icons.circle,
                      size: isNone ? 14 : 10,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: enabled
                      ? AppColors.deepSlate
                      : AppColors.deepSlate.withValues(alpha: 0.4),
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
