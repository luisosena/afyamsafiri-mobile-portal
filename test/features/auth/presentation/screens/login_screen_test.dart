import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afyamsafiri/features/auth/presentation/widgets/login_form.dart';

void main() {
  group('LoginForm', () {
    Widget buildLoginForm({
      void Function({required String email, required String password})? onSubmit,
      bool isLoading = false,
      String? error,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: LoginForm(
              onSubmit: onSubmit ?? ({required String email, required String password}) {},
              isLoading: isLoading,
              error: error,
            ),
          ),
        ),
      );
    }

    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(buildLoginForm());

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('shows error message when error is provided', (tester) async {
      await tester.pumpWidget(buildLoginForm(error: 'Invalid credentials'));

      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('does not show error container when error is null', (tester) async {
      await tester.pumpWidget(buildLoginForm());

      expect(find.byIcon(Icons.error_outline), findsNothing);
    });

    testWidgets('validates empty email field', (tester) async {
      await tester.pumpWidget(buildLoginForm());

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Email or passport number is required'), findsOneWidget);
    });

    testWidgets('validates empty password field', (tester) async {
      await tester.pumpWidget(buildLoginForm());

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'john@example.com');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('calls onSubmit with email and password when valid', (tester) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpWidget(buildLoginForm(
        onSubmit: ({required String email, required String password}) {
          submittedEmail = email;
          submittedPassword = password;
        },
      ));

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'john@example.com');
      await tester.enterText(fields.at(1), 'secret123');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(submittedEmail, 'john@example.com');
      expect(submittedPassword, 'secret123');
    });

    testWidgets('renders Face ID button', (tester) async {
      await tester.pumpWidget(buildLoginForm());

      expect(find.text('Sign in with Face ID'), findsOneWidget);
    });

    testWidgets('renders security badges', (tester) async {
      await tester.pumpWidget(buildLoginForm());

      expect(find.text('End-to-End Encrypted'), findsOneWidget);
      expect(find.text('Secured by Gov.tz'), findsOneWidget);
    });
  });
}
