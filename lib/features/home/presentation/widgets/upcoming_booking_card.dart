import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../../shared/widgets/atoms/status_badge.dart';

class UpcomingBookingCard extends StatelessWidget {
  const UpcomingBookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
  });

  final Booking booking;
  final VoidCallback onViewDetails;

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
                'Latest Booking',
                style: AppTextStyles.inputLabel.copyWith(
                  color: AppColors.deepSlate,
                ),
              ),
              StatusBadge(
                label: 'Submitted',
                type: StatusType.confirmed,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            icon: Icons.flight_land,
            label: 'Entry Reference',
            value: booking.referenceCode ?? '---',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Port of Entry',
            value: booking.portOfEntry,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Arrival Date',
            value: booking.arrivalDate != null
                ? '${booking.arrivalDate!.day}/${booking.arrivalDate!.month}/${booking.arrivalDate!.year}'
                : '---',
          ),
          if (booking.vesselName.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.confirmation_number_outlined,
              label: 'Vessel/Flight',
              value: booking.vesselName,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 44,
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
                'View Booking Details',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}