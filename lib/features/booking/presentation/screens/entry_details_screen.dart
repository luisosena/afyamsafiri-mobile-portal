import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/atoms/select_dropdown.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../providers/booking_provider.dart';
import '../widgets/arrival_wizard_scaffold.dart';

class EntryDetailsScreen extends StatefulWidget {
  const EntryDetailsScreen({super.key});

  @override
  State<EntryDetailsScreen> createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen> {
  final _passportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadPortsOfEntry();
    });
  }

  @override
  void dispose() {
    _passportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return ArrivalWizardScaffold(
      currentStep: 0,
      title: 'Entry Details',
      onCancel: () => context.go('/home'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide your passport number/ID No. to continue.',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.lg),

            TextInput(
              controller: _passportController,
              label: 'Passport Number / ID No.',
              hint: 'Enter Passport Number / ID No.',
              required: true,
              onChanged: provider.setPassportNumber,
            ),
            const SizedBox(height: AppSpacing.md),

            SelectDropdown(
              label: 'Port of Entry',
              hint: 'Enter port of entry',
              value: provider.booking.portOfEntry.isEmpty
                  ? null
                  : provider.booking.portOfEntry,
              items: provider.portsOfEntry,
              required: true,
              onChanged: provider.setPortOfEntry,
            ),
            const SizedBox(height: AppSpacing.md),

            _DatePickerField(
              selectedDate: provider.booking.arrivalDate,
              onDateSelected: provider.setArrivalDate,
            ),
            const SizedBox(height: AppSpacing.xxl),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: provider.isStep1Valid
                    ? () => context.go('/booking/traveler')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: AppColors.textMuted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  'PLACE A BOOKING',
                  style: AppTextStyles.inputLabel.copyWith(
                    color: AppColors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Arrival Date',
            style: AppTextStyles.inputLabel.copyWith(
              color: AppColors.deepSlate,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.urgentRed),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate:
                  selectedDate ?? DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) onDateSelected(date);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.deepSlate.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
                      : 'Select arrival date',
                  style: AppTextStyles.body.copyWith(
                    color:
                        selectedDate != null ? AppColors.deepSlate : AppColors.textMuted,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}