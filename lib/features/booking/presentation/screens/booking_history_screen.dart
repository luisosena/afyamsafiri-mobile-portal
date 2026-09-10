import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_card.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: const AppHeader(title: 'My Bookings'),
      body: SafeArea(
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BookingProvider provider) {
    switch (provider.status) {
      case BookingListStatus.initial:
      case BookingListStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        );

      case BookingListStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.urgentRed),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Failed to load bookings',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  provider.errorMessage ?? 'Unknown error',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: provider.loadBookings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case BookingListStatus.loaded:
        if (provider.bookings.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 64,
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No bookings yet',
                    style: AppTextStyles.heading1.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Create your first arrival booking to get started.',
                    style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => context.go('/booking/new'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Create Booking'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          itemCount: provider.bookings.length,
          itemBuilder: (context, index) {
            final booking = provider.bookings[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: BookingCard(
                booking: booking,
                onViewDetails: () => context.go('/booking/${booking.id}'),
              ),
            );
          },
        );
    }
  }
}
