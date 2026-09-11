import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../providers/booking_provider.dart';
import '../widgets/arrival_form_section.dart';
import '../widgets/arrival_wizard_scaffold.dart';
import '../widgets/symptom_dropdown_grid.dart';

class HealthScreeningScreen extends StatefulWidget {
  const HealthScreeningScreen({super.key});

  @override
  State<HealthScreeningScreen> createState() => _HealthScreeningScreenState();
}

class _HealthScreeningScreenState extends State<HealthScreeningScreen> {
  final _additionalController = TextEditingController();

  @override
  void dispose() {
    _additionalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return ArrivalWizardScaffold(
      currentStep: 3,
      title: 'Health Conditions & Symptoms',
      onBack: () => context.go('/booking/visit'),
      onCancel: () => context.go('/home'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            ArrivalFormSection(
              title:
                  'Have you experienced any health problems/conditions in the last 21 days (3 weeks)? If Yes, please tick one or two of the following:',
              children: [
                SymptomDropdownGrid(
                  symptoms: provider.booking.symptoms,
                  onSymptomChanged: provider.setSymptomValue,
                ),
              ],
            ),
            ArrivalFormSection(
              title: 'Additional Symptoms',
              children: [
                TextInput(
                  controller: _additionalController,
                  label: 'Other signs and symptoms (comma separated)',
                  hint: 'Enter Other signs and symptoms (comma separated)',
                  onChanged: provider.setAdditionalSymptoms,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: provider.isStep4Valid
                    ? () => context.go('/booking/review')
                    : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}