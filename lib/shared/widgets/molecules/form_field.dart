import 'package:flutter/material.dart';
import '../atoms/text_input.dart';

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.required = false,
    this.enabled = true,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
  });

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool required;
  final bool enabled;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      controller: controller,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      required: required,
      enabled: enabled,
      suffixIcon: suffixIcon,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
