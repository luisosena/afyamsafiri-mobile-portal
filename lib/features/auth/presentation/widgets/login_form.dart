import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../../../../shared/widgets/atoms/password_input.dart';
import '../../../../shared/widgets/atoms/primary_button.dart';
import '../../../../shared/widgets/atoms/secondary_button.dart';
import '../widgets/security_badge.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.error,
  });

  final void Function({required String email, required String password}) onSubmit;
  final bool isLoading;
  final String? error;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.error!,
                      style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextInput(
            controller: _emailController,
            label: 'Email or Passport Number',
            hint: 'Enter your email or passport number',
            required: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Email or passport number is required' : null,
          ),
          const SizedBox(height: 16),
          PasswordInput(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            required: true,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Password is required' : null,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Forgot?',
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Log In',
            onPressed: _submit,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: 'Sign in with Face ID',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          const Center(
            child: SecurityBadge(label: 'End-to-End Encrypted', icon: Icons.lock_outline),
          ),
          const SizedBox(height: 8),
          const Center(
            child: SecurityBadge(label: 'Secured by Gov.tz', icon: Icons.verified_user_outlined),
          ),
        ],
      ),
    );
  }
}