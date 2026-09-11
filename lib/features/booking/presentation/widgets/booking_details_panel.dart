import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/molecules/summary_row.dart';
import '../../../../shared/widgets/atoms/status_badge.dart';
import '../../domain/entities/booking.dart';

class BookingDetailsPanel extends StatelessWidget {
  const BookingDetailsPanel({
    super.key,
    required this.booking,
    required this.onNewBooking,
    this.onCancel,
  });

  final Booking booking;
  final VoidCallback onNewBooking;
  final VoidCallback? onCancel;

  StatusType get _statusType {
    switch (booking.status) {
      case BookingStatus.submitted:
        return StatusType.confirmed;
      case BookingStatus.pendingSync:
        return StatusType.pendingSync;
      case BookingStatus.draft:
        return StatusType.draft;
      case BookingStatus.cancelled:
        return StatusType.cancelled;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.submitted:
        return 'Submitted';
      case BookingStatus.pendingSync:
        return 'Pending Sync';
      case BookingStatus.draft:
        return 'Draft';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // QR Authorization block
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.lightAccent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.deepSlate.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 64,
                      color: AppColors.deepSlate.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'QR Pass',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Present this QR code at the point of entry',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Status + Reference
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reference',
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
                Text(
                  booking.referenceCode ?? '---',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepSlate,
                  ),
                ),
              ],
            ),
            StatusBadge(label: _statusLabel, type: _statusType),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Traveler info
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
                'Traveler Information',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSlate,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SummaryRow(
                label: 'Name',
                value:
                    '${booking.firstName} ${booking.middleName.isNotEmpty ? '${booking.middleName} ' : ''}${booking.surname}',
              ),
              const Divider(height: 1),
              SummaryRow(
                label: 'Passport/ID',
                value: booking.passportNumber,
              ),
              const Divider(height: 1),
              SummaryRow(
                label: 'Nationality',
                value: booking.nationality,
              ),
              const Divider(height: 1),
              SummaryRow(
                label: 'Gender',
                value: booking.gender,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Arrival info
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
                'Arrival Information',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSlate,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SummaryRow(
                label: 'Port of Entry',
                value: booking.portOfEntry,
              ),
              const Divider(height: 1),
              SummaryRow(
                label: 'Arrival Date',
                value: booking.arrivalDate != null
                    ? '${booking.arrivalDate!.day}/${booking.arrivalDate!.month}/${booking.arrivalDate!.year}'
                    : '---',
              ),
              if (booking.vesselName.isNotEmpty) ...[
                const Divider(height: 1),
                SummaryRow(
                  label: 'Vessel/Flight',
                  value: booking.vesselName,
                ),
              ],
              if (booking.purposeOfVisit.isNotEmpty) ...[
                const Divider(height: 1),
                SummaryRow(
                  label: 'Purpose of Visit',
                  value: booking.purposeOfVisit,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Actions
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onNewBooking,
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'New Booking',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              padding: EdgeInsets.zero,
              side: const BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
          ),
        ),
        if (onCancel != null) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: Text(
                'Cancel Booking',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.urgentRed,
                padding: EdgeInsets.zero,
                side: const BorderSide(color: AppColors.urgentRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}