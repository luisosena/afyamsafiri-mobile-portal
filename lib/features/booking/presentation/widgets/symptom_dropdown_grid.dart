import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/booking.dart';
import 'yes_no_dropdown.dart';

class SymptomDropdownGrid extends StatelessWidget {
  const SymptomDropdownGrid({
    super.key,
    required this.symptoms,
    required this.onSymptomChanged,
  });

  final List<SymptomEntry> symptoms;
  final void Function(int index, bool? value) onSymptomChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(symptoms.length, (index) {
        final symptom = symptoms[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: YesNoDropdown(
            label: symptom.name,
            value: symptom.value,
            required: true,
            onChanged: (val) => onSymptomChanged(index, val),
          ),
        );
      }),
    );
  }
}