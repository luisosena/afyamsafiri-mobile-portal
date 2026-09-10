import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/molecules/editable_section.dart';
import '../../../../shared/widgets/molecules/summary_row.dart';
import '../../../../shared/widgets/atoms/checkbox.dart';
import '../providers/booking_provider.dart';

class BookingReviewPanel extends StatelessWidget {
  const BookingReviewPanel({super.key, required this.onEditArrival});

  final VoidCallback onEditArrival;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Booking',
          style: AppTextStyles.heading1.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Verify your details before submitting.',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        EditableSection(
          title: 'Arrival Details',
          onEdit: onEditArrival,
          children: [
            SummaryRow(
              label: 'Point of Entry',
              value: provider.selectedPointOfEntry ?? '—',
            ),
            const Divider(height: 1),
            SummaryRow(
              label: 'Arrival Date',
              value: provider.formattedDate.isNotEmpty
                  ? provider.formattedDate
                  : '—',
            ),
            const Divider(height: 1),
            SummaryRow(
              label: 'Arrival Time',
              value: provider.formattedTime.isNotEmpty
                  ? provider.formattedTime
                  : '—',
            ),
            if (provider.flightNumber.isNotEmpty) ...[
              const Divider(height: 1),
              SummaryRow(
                label: 'Flight / Transport',
                value: provider.flightNumber,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Screening Declaration',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSlate,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'I confirm that I will complete the required health screening before arrival at the point of entry. I understand that failure to do so may result in delays or additional screening upon arrival.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCheckbox(
                label: 'I confirm the health screening declaration',
                value: provider.healthDeclaration,
                onChanged: (val) => provider.setHealthDeclaration(val ?? false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
