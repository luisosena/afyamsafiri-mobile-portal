import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/screening_provider.dart';

class AdditionalHealthForm extends StatelessWidget {
  const AdditionalHealthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScreeningProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Health Information',
          style: AppTextStyles.heading1.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Please answer the following questions.',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        _YesNoQuestion(
          question: 'Have you been in contact with anyone with an infectious disease in the last 14 days?',
          value: provider.hasContactWithInfectiousDisease,
          onChanged: provider.setContactWithInfectiousDisease,
        ),
        const SizedBox(height: AppSpacing.md),

        _YesNoQuestion(
          question: 'Is the purpose of your travel medical (seeking treatment)?',
          value: provider.isMedicalTravelPurpose,
          onChanged: provider.setMedicalTravelPurpose,
        ),
        const SizedBox(height: AppSpacing.lg),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.lightAccent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Additional questions may be asked based on your point of entry and travel history.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.deepSlate,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _YesNoQuestion extends StatelessWidget {
  const _YesNoQuestion({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final String question;
  final bool? value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.deepSlate.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextStyles.body.copyWith(
              color: AppColors.deepSlate,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _ChoiceButton(
                  label: 'Yes',
                  selected: value == true,
                  onTap: () => onChanged(true),
                  selectedColor: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ChoiceButton(
                  label: 'No',
                  selected: value == false,
                  onTap: () => onChanged(false),
                  selectedColor: AppColors.deepSlate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.1)
              : AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: selected
                ? selectedColor
                : AppColors.deepSlate.withValues(alpha: 0.15),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: selected ? selectedColor : AppColors.textMuted,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
