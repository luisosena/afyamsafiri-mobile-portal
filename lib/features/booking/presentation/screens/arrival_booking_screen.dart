import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../../../../shared/widgets/atoms/primary_button.dart';
import '../providers/booking_provider.dart';
import '../widgets/arrival_booking_form.dart';

class ArrivalBookingScreen extends StatelessWidget {
  const ArrivalBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppHeader(
        title: 'New Booking',
        showBack: true,
        onBack: () {
          provider.resetForm();
          context.go('/home');
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: Column(
            children: [
              const ArrivalBookingForm(),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Continue to Review',
                enabled: provider.isFormValid,
                onPressed: () => context.go('/booking/review'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
