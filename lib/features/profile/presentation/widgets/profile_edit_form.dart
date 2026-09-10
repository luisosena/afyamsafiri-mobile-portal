import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/atoms/primary_button.dart';
import '../../../../shared/widgets/atoms/secondary_button.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../../domain/entities/profile.dart';

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({
    super.key,
    required this.profile,
    required this.onSave,
    required this.onCancel,
    this.isSaving = false,
  });

  final Profile profile;
  final ValueChanged<Map<String, String>> onSave;
  final VoidCallback onCancel;
  final bool isSaving;

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nationalityController;
  late final TextEditingController _passportController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _nationalityController = TextEditingController(text: widget.profile.nationality ?? '');
    _passportController = TextEditingController(text: widget.profile.passportNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave({
      'fullName': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'nationality': _nationalityController.text.trim(),
      'passportNumber': _passportController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Profile',
              style: AppTextStyles.inputLabel.copyWith(
                color: AppColors.deepSlate,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextInput(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              required: true,
              validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextInput(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
              required: true,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextInput(
              controller: _phoneController,
              label: 'Phone',
              hint: 'e.g. +255712345678',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.md),
            TextInput(
              controller: _nationalityController,
              label: 'Nationality',
              hint: 'e.g. Tanzania',
            ),
            const SizedBox(height: AppSpacing.md),
            TextInput(
              controller: _passportController,
              label: 'Passport Number',
              hint: 'e.g. AB1234567',
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Cancel',
                    onPressed: widget.isSaving ? null : widget.onCancel,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: PrimaryButton(
                    label: widget.isSaving ? 'Saving...' : 'Save',
                    onPressed: widget.isSaving ? null : _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
