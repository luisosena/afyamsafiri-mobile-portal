import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../providers/screening_provider.dart';
import '../widgets/health_screening_wizard.dart';

class HealthScreeningScreen extends StatelessWidget {
  const HealthScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScreeningProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppHeader(
        title: 'Health Screening',
        showBack: true,
        onBack: () {
          if (provider.currentStep > 0) {
            provider.prevStep();
          } else {
            context.go('/home');
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerPadding,
          ),
          child: HealthScreeningWizard(
            onSubmit: () async {
              await provider.submitScreening('current-booking-id');
              if (provider.status == ScreeningStatus.success && context.mounted) {
                context.go('/booking/review');
              }
            },
            onSaveDraft: () async {
              await provider.saveDraft('current-booking-id');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Screening draft saved.'),
                    backgroundColor: AppColors.primaryBlue,
                  ),
                );
              }
            },
            onCancel: () => context.go('/home'),
          ),
        ),
      ),
    );
  }
}
