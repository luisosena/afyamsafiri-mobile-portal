import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class SelectDropdown extends StatelessWidget {
  const SelectDropdown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.required = false,
    this.errorText,
  });

  final String? label;
  final String? hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final bool required;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label!,
              style: AppTextStyles.inputLabel.copyWith(color: AppColors.deepSlate),
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
        ],
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: AppTextStyles.body),
                  ))
              .toList(),
          onChanged: onChanged,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint ?? 'Select an option',
            errorText: errorText,
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
