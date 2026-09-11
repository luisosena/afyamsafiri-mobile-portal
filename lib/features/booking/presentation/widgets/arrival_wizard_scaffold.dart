import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class ArrivalWizardScaffold extends StatelessWidget {
  const ArrivalWizardScaffold({
    super.key,
    required this.currentStep,
    required this.title,
    required this.child,
    this.onBack,
    this.onCancel,
  });

  final int currentStep;
  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;

  static const List<String> _stepLabels = [
    'Entry',
    'Traveler',
    'Visit',
    'Health',
    'Submit',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.deepSlate),
                onPressed: onBack,
              )
            : null,
        actions: [
          if (onCancel != null)
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.urgentRed,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Step indicator
          _StepIndicator(
            currentStep: currentStep,
            labels: _stepLabels,
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerPadding,
              AppSpacing.md,
              AppSpacing.containerPadding,
              AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: AppTextStyles.heading1.copyWith(fontSize: 20),
              ),
            ),
          ),
          // Content
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.labels,
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? AppColors.successGreen
                              : isActive
                                  ? AppColors.primaryBlue
                                  : AppColors.surfaceGray,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: 16,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: isActive
                                        ? AppColors.white
                                        : AppColors.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: AppTextStyles.caption.copyWith(
                          color: isActive
                              ? AppColors.primaryBlue
                              : isCompleted
                                  ? AppColors.successGreen
                                  : AppColors.textMuted,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (index < labels.length - 1)
                  Container(
                    width: 20,
                    height: 2,
                    color: isCompleted
                        ? AppColors.successGreen
                        : AppColors.surfaceGray,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}