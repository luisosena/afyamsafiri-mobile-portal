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
                booking.referenceCode ?? '---',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSlate,
                ),
              ),
              StatusBadge(label: _statusLabel, type: _statusType),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (booking.portOfEntry.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    booking.portOfEntry,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMuted),
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
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${booking.arrivalDate!.day}/${booking.arrivalDate!.month}/${booking.arrivalDate!.year}',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textMuted),
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
                padding: EdgeInsets.zero,
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