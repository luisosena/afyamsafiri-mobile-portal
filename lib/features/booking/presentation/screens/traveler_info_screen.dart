import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/atoms/select_dropdown.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../providers/booking_provider.dart';
import '../widgets/arrival_form_section.dart';
import '../widgets/arrival_wizard_scaffold.dart';

class TravelerInfoScreen extends StatefulWidget {
  const TravelerInfoScreen({super.key});

  @override
  State<TravelerInfoScreen> createState() => _TravelerInfoScreenState();
}

class _TravelerInfoScreenState extends State<TravelerInfoScreen> {
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadNationalities();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return ArrivalWizardScaffold(
      currentStep: 1,
      title: "Traveler's Information",
      onBack: () => context.go('/booking'),
      onCancel: () => context.go('/home'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            ArrivalFormSection(
              title: 'Personal information',
              children: [
                TextInput(
                  controller: _firstNameController,
                  label: 'First name',
                  hint: 'Enter First name',
                  required: true,
                  onChanged: provider.setFirstName,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _middleNameController,
                  label: 'Middle name',
                  hint: 'Enter Middle name',
                  onChanged: provider.setMiddleName,
                ),
                const SizedBox(height: AppSpacing.md),
                TextInput(
                  controller: _surnameController,
                  label: 'Surname',
                  hint: 'Enter Surname',
                  required: true,
                  onChanged: provider.setSurname,
                ),
                const SizedBox(height: AppSpacing.md),
                SelectDropdown(
                  label: 'Gender',
                  hint: 'Select Gender',
                  value: provider.booking.gender.isEmpty
                      ? null
                      : provider.booking.gender,
                  items: const ['Male', 'Female', 'Other'],
                  required: true,
                  onChanged: provider.setGender,
                ),
                const SizedBox(height: AppSpacing.md),
                _DatePickerField(
                  label: 'Date of birth',
                  selectedDate: provider.booking.dateOfBirth,
                  onDateSelected: provider.setDateOfBirth,
                ),
                const SizedBox(height: AppSpacing.md),
                SelectDropdown(
                  label: 'Nationality',
                  hint: 'Select Nationality',
                  value: provider.booking.nationality.isEmpty
                      ? null
                      : provider.booking.nationality,
                  items: provider.nationalities,
                  required: true,
                  onChanged: provider.setNationality,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: provider.isStep2Valid
                    ? () => context.go('/booking/visit')
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

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF0F172A),
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
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
                color: const Color(0xFF0F172A).withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
                      : 'dd/mm/yyyy',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: selectedDate != null
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}