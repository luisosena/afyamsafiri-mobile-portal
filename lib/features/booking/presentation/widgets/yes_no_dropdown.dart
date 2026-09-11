import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class YesNoDropdown extends StatelessWidget {
  const YesNoDropdown({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.required = false,
  });

  final String label;
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.inputLabel.copyWith(
              color: AppColors.deepSlate,
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.urgentRed),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value == null
              ? null
              : value!
                  ? 'Yes'
                  : 'No',
          items: const [
            DropdownMenuItem(value: 'Yes', child: Text('Yes')),
            DropdownMenuItem(value: 'No', child: Text('No')),
          ],
          onChanged: onChanged == null
              ? null
              : (val) => onChanged!(val == 'Yes'),
          style: AppTextStyles.body,
          decoration: const InputDecoration(
            hintText: 'Select an option',
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
        ),
      ],
    );
  }
}