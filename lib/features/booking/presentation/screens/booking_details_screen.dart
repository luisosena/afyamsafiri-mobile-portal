import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../../domain/entities/booking.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_details_panel.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final booking = provider.bookings
        .where((d) => d.id == bookingId)
        .firstOrNull;

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
                  onNewBooking: () => context.go('/booking'),
                  onCancel: booking.status == BookingStatus.submitted
                      ? () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Cancel Booking'),
                              content: Text(
                                'Are you sure you want to cancel booking ${booking.referenceCode}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Keep'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.urgentRed,
                                  ),
                                  child: const Text('Cancel Booking'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true && context.mounted) {
                            await provider.cancelBooking(booking.id!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Booking ${booking.referenceCode} cancelled.',
                                  ),
                                  backgroundColor: AppColors.deepSlate,
                                ),
                              );
                              context.go('/bookings');
                            }
                          }
                        }
                      : null,
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