import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_confirmation_panel.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final booking = provider.confirmedBooking;

    if (booking == null) {
      return Scaffold(
        appBar: const AppHeader(title: 'Booking Confirmed', showBack: false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textMuted),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No booking data found.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: const AppHeader(title: 'Booking Confirmed', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: BookingConfirmationPanel(
            booking: booking,
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Confirmation saved. (Mock)'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            onBackHome: () {
              provider.resetForm();
              context.go('/home');
            },
          ),
        ),
      ),
    );
  }
}
