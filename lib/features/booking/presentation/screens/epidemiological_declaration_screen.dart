import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/booking_provider.dart';
import '../widgets/arrival_form_section.dart';
import '../widgets/arrival_wizard_scaffold.dart';
import '../widgets/booking_checkbox.dart';
import '../widgets/yes_no_dropdown.dart';

class EpidemiologicalDeclarationScreen extends StatelessWidget {
  const EpidemiologicalDeclarationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final isSubmitting = provider.currentStatus == BookingSubmitStatus.submitting;

    return ArrivalWizardScaffold(
      currentStep: 4,
      title: 'Epidemiological Risk & Declaration',
      onBack: () => context.go('/booking/health'),
      onCancel: () => _showCancelDialog(context, provider),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            ArrivalFormSection(
              title:
                  'In the last 21 days (3 weeks) have you: Put Yes or No to each question',
              children: [
                YesNoDropdown(
                  label:
                      'Visited/resided in an area with ongoing disease outbreak i.e Ebola, Corona or Yellow fever',
                  value: provider.booking.visitedOutbreakArea,
                  required: true,
                  onChanged: provider.setVisitedOutbreakArea,
                ),
                const SizedBox(height: AppSpacing.md),
                YesNoDropdown(
                  label:
                      'Participated in taking care of the sick person with symptoms above?',
                  value: provider.booking.caredForSick,
                  required: true,
                  onChanged: provider.setCaredForSick,
                ),
                const SizedBox(height: AppSpacing.md),
                YesNoDropdown(
                  label: 'Participated in the burial of the dead person?',
                  value: provider.booking.participatedInBurial,
                  required: true,
                  onChanged: provider.setParticipatedInBurial,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            BookingCheckbox(
              value: provider.booking.declarationAccepted,
              onChanged: (val) =>
                  provider.setDeclarationAccepted(val ?? false),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => _showCancelDialog(context, provider),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.urgentRed,
                      side: const BorderSide(color: AppColors.urgentRed),
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.isStep5Valid && !isSubmitting
                        ? () => _submit(context, provider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: AppColors.textMuted,
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(
    BuildContext context,
    BookingProvider provider,
  ) async {
    final success = await provider.submit();
    if (context.mounted && success) {
      context.go('/booking/confirmed');
    }
  }

  void _showCancelDialog(
    BuildContext context,
    BookingProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel? All entered data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continue Editing'),
          ),
          TextButton(
            onPressed: () {
              provider.reset();
              Navigator.pop(ctx);
              context.go('/home');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.urgentRed),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}