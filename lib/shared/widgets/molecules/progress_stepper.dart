import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class ProgressStepper extends StatelessWidget {
  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.labels,
  });

  final int currentStep;
  final int totalSteps;
  final List<String>? labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;

            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryBlue : AppColors.textMuted.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.deepSlate,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (labels != null && currentStep <= labels!.length)
              Text(
                labels![currentStep - 1],
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
          ],
        ),
      ],
    );
  }
}
