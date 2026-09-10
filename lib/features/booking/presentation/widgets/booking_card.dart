import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/atoms/status_badge.dart';
import '../../domain/entities/booking.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
  });

  final Booking booking;
  final VoidCallback onViewDetails;

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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.referenceCode,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSlate,
                ),
              ),
              StatusBadge(label: _statusLabel, type: _statusType),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (booking.pointOfEntry != null) ...[
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    booking.pointOfEntry!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          if (booking.arrivalDate != null) ...[
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${booking.arrivalDate}${booking.arrivalTime != null ? '  ${booking.arrivalTime}' : ''}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
              ),
              child: Text(
                'View Details',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
