import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../../../../shared/widgets/atoms/primary_button.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_review_panel.dart';

class BookingReviewScreen extends StatelessWidget {
  const BookingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppHeader(
        title: 'Review Booking',
        showBack: true,
        onBack: () => context.go('/booking/new'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: Column(
            children: [
              BookingReviewPanel(
                onEditArrival: () => context.go('/booking/new'),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Submit Booking',
                enabled: provider.isReviewValid,
                isLoading: provider.submitStatus == BookingSubmitStatus.submitting,
                onPressed: () async {
                  await provider.submitBooking();
                  if (provider.submitStatus == BookingSubmitStatus.success) {
                    if (context.mounted) context.go('/booking/confirmed');
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
