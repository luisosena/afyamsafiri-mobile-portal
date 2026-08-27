import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.countryCode = '+255',
    this.errorText,
    this.required = false,
    this.onChanged,
    this.validator,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String countryCode;
  final String? errorText;
  final bool required;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

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
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          onChanged: onChanged,
          validator: validator,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint ?? 'Phone number',
            errorText: errorText,
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Text(
                countryCode,
                style: AppTextStyles.body.copyWith(color: AppColors.deepSlate),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
      ],
    );
  }
}
