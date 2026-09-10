import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_details_panel.dart';
import '../widgets/cancel_booking_modal.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final booking = provider.bookings.where((b) => b.id == bookingId).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppHeader(
        title: 'Booking Details',
        showBack: true,
        onBack: () => context.go('/bookings'),
      ),
      body: SafeArea(
        child: booking == null
            ? _buildNotFound(context)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                child: BookingDetailsPanel(
                  booking: booking,
                  onEdit: () => context.go('/booking/new'),
                  onCancel: () async {
                    final confirmed = await CancelBookingModal.show(
                      context,
                      referenceCode: booking.referenceCode,
                    );
                    if (confirmed == true && context.mounted) {
                      await provider.cancelBooking(booking.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking ${booking.referenceCode} cancelled.'),
                            backgroundColor: AppColors.deepSlate,
                          ),
                        );
                        context.go('/bookings');
                      }
                    }
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.md),
          const Text('Booking not found.'),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go('/bookings'),
            child: const Text('Back to Bookings'),
          ),
        ],
      ),
    );
  }
}
