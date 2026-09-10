import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/atoms/select_dropdown.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../providers/booking_provider.dart';

class ArrivalBookingForm extends StatefulWidget {
  const ArrivalBookingForm({super.key});

  @override
  State<ArrivalBookingForm> createState() => _ArrivalBookingFormState();
}

class _ArrivalBookingFormState extends State<ArrivalBookingForm> {
  final _flightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadPointsOfEntry();
    });
  }

  @override
  void dispose() {
    _flightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final poeNames = provider.pointsOfEntry.map((p) => p.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Arrival Details',
          style: AppTextStyles.heading1.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Enter your arrival information to register with Tanzania port health.',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        SelectDropdown(
          label: 'Point of Entry',
          hint: 'Search or select point of entry',
          value: provider.selectedPointOfEntry,
          items: poeNames,
          required: true,
          onChanged: provider.setPointOfEntry,
        ),
        const SizedBox(height: AppSpacing.md),

        _DatePickerField(
          selectedDate: provider.selectedDate,
          onDateSelected: provider.setDate,
        ),
        const SizedBox(height: AppSpacing.md),

        _TimePickerField(
          selectedTime: provider.selectedTime,
          onTimeSelected: provider.setTime,
        ),
        const SizedBox(height: AppSpacing.md),

        TextInput(
          controller: _flightController,
          label: 'Flight / Transport Number',
          hint: 'e.g. KQ480',
          helperText: 'Enter your flight, bus, or vessel number',
          onChanged: provider.setFlightNumber,
        ),
        const SizedBox(height: AppSpacing.md),

        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.lightAccent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Ensure your arrival details match your travel ticket to avoid issues at the point of entry.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.deepSlate,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
              initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
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
              border: Border.all(color: AppColors.deepSlate.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Select arrival date',
                  style: AppTextStyles.body.copyWith(
                    color: selectedDate != null
                        ? AppColors.deepSlate
                        : AppColors.textMuted,
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

class _TimePickerField extends StatelessWidget {
  const _TimePickerField({
    required this.selectedTime,
    required this.onTimeSelected,
  });

  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay?> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Arrival Time',
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
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (time != null) onTimeSelected(time);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.deepSlate.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime != null
                      ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                      : 'Select arrival time',
                  style: AppTextStyles.body.copyWith(
                    color: selectedTime != null
                        ? AppColors.deepSlate
                        : AppColors.textMuted,
                  ),
                ),
                Icon(
                  Icons.access_time,
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
