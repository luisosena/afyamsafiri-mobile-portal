import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'text_input.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.required = false,
    this.onChanged,
    this.validator,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool required;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      controller: widget.controller,
      label: widget.label ?? 'Password',
      hint: widget.hint ?? 'Enter your password',
      errorText: widget.errorText,
      required: widget.required,
      obscureText: _obscure,
      onChanged: widget.onChanged,
      validator: widget.validator,
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textMuted,
          size: 20,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
