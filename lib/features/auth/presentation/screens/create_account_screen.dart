import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/molecules/app_header.dart';
import '../../../../shared/widgets/molecules/progress_stepper.dart';
import '../providers/auth_provider.dart';
import '../widgets/registration_form.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.isAuthenticated) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(
        title: 'Create Account',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressStepper(
                currentStep: 1,
                totalSteps: 2,
                labels: ['Personal Details', 'Verification'],
              ),
              const SizedBox(height: 24),
              Text(
                'Personal Details',
                style: AppTextStyles.heading1.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter your details to create your traveller account.',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              RegistrationForm(
                isLoading: authProvider.status == AuthStatus.loading,
                error: authProvider.errorMessage,
                onSubmit: ({
                  required String fullName,
                  required String email,
                  required String password,
                  String? phone,
                  String? nationality,
                  String? passportNumber,
                }) {
                  authProvider.register(
                    fullName: fullName,
                    email: email,
                    password: password,
                    phone: phone,
                    nationality: nationality,
                    passportNumber: passportNumber,
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Log In',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}