import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class ScreeningProgressStepper extends StatelessWidget {
  const ScreeningProgressStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  static const _stepLabels = [
    'Travel',
    'Symptoms',
    'Vaccine',
    'Health',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isActive
                            ? AppColors.primaryBlue
                            : AppColors.deepSlate.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1)
                    const SizedBox(width: 4),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${currentStep + 1} of $totalSteps',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            Text(
              _stepLabels[currentStep],
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
