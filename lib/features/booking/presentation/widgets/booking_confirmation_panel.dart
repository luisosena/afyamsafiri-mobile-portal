import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/molecules/summary_row.dart';
import '../../../../shared/widgets/atoms/status_badge.dart';
import '../../domain/entities/booking.dart';

class BookingConfirmationPanel extends StatelessWidget {
  const BookingConfirmationPanel({
    super.key,
    required this.booking,
    required this.onSave,
    required this.onBackHome,
  });

  final Booking booking;
  final VoidCallback onSave;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.successGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            color: AppColors.successGreen,
            size: 48,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Booking Confirmed',
          style: AppTextStyles.heading1.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Your arrival has been registered successfully.',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Registration code
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.lightAccent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            children: [
              Text(
                'Registration Code',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                booking.referenceCode,
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 24,
                  color: AppColors.primaryBlue,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // QR placeholder
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.deepSlate.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_2,
                size: 80,
                color: AppColors.deepSlate.withValues(alpha: 0.3),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'QR Pass',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            children: [
              SummaryRow(
                label: 'Status',
                value: '',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: StatusBadge(
                  label: 'Confirmed',
                  type: StatusType.confirmed,
                ),
              ),
              const Divider(height: 1),
              SummaryRow(
                label: 'Point of Entry',
                value: booking.pointOfEntry ?? '—',
              ),
              const Divider(height: 1),
              SummaryRow(
                label: 'Arrival Date',
                value: booking.arrivalDate ?? '—',
              ),
              const Divider(height: 1),
              SummaryRow(
                label: 'Arrival Time',
                value: booking.arrivalTime ?? '—',
              ),
              if (booking.flightNumber != null) ...[
                const Divider(height: 1),
                SummaryRow(
                  label: 'Flight / Transport',
                  value: booking.flightNumber!,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Actions
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.download_outlined, size: 20),
            label: Text(
              'Save Confirmation',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: onBackHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              side: const BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Text(
              'Back to Home',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
