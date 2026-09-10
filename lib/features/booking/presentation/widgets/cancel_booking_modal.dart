import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class CancelBookingModal extends StatelessWidget {
  const CancelBookingModal({
    super.key,
    required this.referenceCode,
    required this.onConfirm,
    required this.onKeep,
  });

  final String referenceCode;
  final VoidCallback onConfirm;
  final VoidCallback onKeep;

  static Future<bool?> show(
    BuildContext context, {
    required String referenceCode,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => CancelBookingModal(
        referenceCode: referenceCode,
        onConfirm: () => Navigator.of(context).pop(true),
        onKeep: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.urgentRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.urgentRed,
                size: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Cancel Booking',
              style: AppTextStyles.heading1.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Are you sure you want to cancel booking $referenceCode? This action cannot be undone.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.urgentRed,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  'Cancel Booking',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onKeep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.deepSlate,
                  side: BorderSide(
                    color: AppColors.deepSlate.withValues(alpha: 0.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  'Keep Booking',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
