import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/screening_provider.dart';
import 'screening_progress_stepper.dart';
import 'travel_history_form.dart';
import 'symptoms_form.dart';
import 'vaccination_form.dart';
import 'additional_health_form.dart';
import 'screening_review_form.dart';

class HealthScreeningWizard extends StatelessWidget {
  const HealthScreeningWizard({
    super.key,
    required this.onSubmit,
    required this.onSaveDraft,
    required this.onCancel,
  });

  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScreeningProvider>();

    return Column(
      children: [
        ScreeningProgressStepper(
          currentStep: provider.currentStep,
          totalSteps: ScreeningProvider.totalSteps,
        ),
        const SizedBox(height: AppSpacing.lg),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: _buildStepContent(provider),
          ),
        ),

        // Bottom actions
        Container(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceGray,
            border: Border(
              top: BorderSide(
                color: AppColors.deepSlate.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (provider.canGoBack)
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: provider.prevStep,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.deepSlate,
                            side: BorderSide(
                              color: AppColors.deepSlate.withValues(alpha: 0.2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (provider.canGoBack) const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: provider.canGoBack ? 2 : 1,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: provider.isCurrentStepValid
                            ? () {
                                if (provider.isLastStep) {
                                  onSubmit();
                                } else {
                                  provider.nextStep();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor:
                              AppColors.primaryBlue.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                          ),
                        ),
                        child: Text(
                          provider.isLastStep ? 'Submit Screening' : 'Continue',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: GestureDetector(
                  onTap: onSaveDraft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      'Save & Continue Later',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(ScreeningProvider provider) {
    switch (provider.currentStep) {
      case 0:
        return const TravelHistoryForm();
      case 1:
        return const SymptomsForm();
      case 2:
        return const VaccinationForm();
      case 3:
        return const AdditionalHealthForm();
      case 4:
        return ScreeningReviewForm(
          onEditStep: provider.goToStep,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
