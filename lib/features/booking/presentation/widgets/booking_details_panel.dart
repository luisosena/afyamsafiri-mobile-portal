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
    required this.onEdit,
    required this.onCancel,
  });

  final Booking booking;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  StatusType get _statusType {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return StatusType.confirmed;
      case BookingStatus.completed:
        return StatusType.completed;
      case BookingStatus.cancelled:
        return StatusType.cancelled;
      case BookingStatus.pending:
        return StatusType.urgent;
      case BookingStatus.draft:
      case BookingStatus.pendingSync:
        return StatusType.draft;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.draft:
        return 'Draft';
      case BookingStatus.pendingSync:
        return 'Pending Sync';
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
                Text(
                  booking.referenceCode,
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

        // Arrival info grid
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
        const SizedBox(height: AppSpacing.md),

        // Health screening status
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: booking.isConfirmed
                      ? AppColors.successGreen.withValues(alpha: 0.12)
                      : AppColors.urgentRed.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  booking.isConfirmed
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_rounded,
                  color: booking.isConfirmed
                      ? AppColors.successGreen
                      : AppColors.urgentRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Screening',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepSlate,
                      ),
                    ),
                    Text(
                      booking.isConfirmed
                          ? 'Screening completed'
                          : 'Screening required',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Actions
        if (!booking.isCancelled && !booking.isCompleted) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(
                'Edit Booking',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          ),
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
