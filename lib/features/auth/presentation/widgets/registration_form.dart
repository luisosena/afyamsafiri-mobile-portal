import 'package:flutter/material.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../../../../shared/widgets/atoms/password_input.dart';
import '../../../../shared/widgets/atoms/phone_input.dart';
import '../../../../shared/widgets/atoms/select_dropdown.dart';
import '../../../../shared/widgets/atoms/checkbox.dart';
import '../../../../shared/widgets/atoms/primary_button.dart';
import '../widgets/security_badge.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key, required this.onSubmit, this.isLoading = false, this.error});

  final void Function({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? nationality,
    String? passportNumber,
  }) onSubmit;
  final bool isLoading;
  final String? error;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nationality;
  bool _acceptedTerms = false;

  final List<String> _nationalities = [
    'Tanzania',
    'Kenya',
    'Uganda',
    'Rwanda',
    'Burundi',
    'South Sudan',
    'DR Congo',
    'Ethiopia',
    'Somalia',
    'Mozambique',
    'Other',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    widget.onSubmit(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      nationality: _nationality,
      passportNumber: _passportController.text.trim().isNotEmpty ? _passportController.text.trim() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.error!,
                style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextInput(
            controller: _fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            required: true,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
          ),
          const SizedBox(height: 16),
          TextInput(
            controller: _passportController,
            label: 'Passport / ID Number',
            hint: 'Enter your passport or ID number',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          SelectDropdown(
            label: 'Nationality',
            hint: 'Select your nationality',
            value: _nationality,
            items: _nationalities,
            onChanged: (v) => setState(() => _nationality = v),
          ),
          const SizedBox(height: 16),
          TextInput(
            controller: _emailController,
            label: 'Email Address',
            hint: 'Enter your email address',
            required: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          PhoneInput(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '712 345 678',
            validator: (v) => v != null && v.isNotEmpty && v.length < 6 ? 'Enter a valid phone number' : null,
          ),
          const SizedBox(height: 16),
          PasswordInput(
            controller: _passwordController,
            label: 'Password',
            hint: 'Create a password',
            required: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 8) return 'Password must be at least 8 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          PasswordInput(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            required: true,
            validator: (v) {
              if (v != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppCheckbox(
            value: _acceptedTerms,
            onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
            label: 'I agree to the Terms of Service and Privacy Policy',
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Create Account',
            onPressed: _submit,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: 16),
          const Center(
            child: SecurityBadge(label: 'End-to-End Encrypted', icon: Icons.lock_outline),
          ),
          const SizedBox(height: 12),
          const Center(
            child: SecurityBadge(label: 'Secured by Gov.tz', icon: Icons.verified_user_outlined),
          ),
        ],
      ),
    );
  }
}