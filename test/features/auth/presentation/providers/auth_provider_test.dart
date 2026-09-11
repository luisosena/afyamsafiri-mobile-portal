import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afyamsafiri/features/auth/domain/entities/user.dart';
import 'package:afyamsafiri/features/auth/domain/repositories/auth_repository.dart';
import 'package:afyamsafiri/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late AuthProvider provider;

  const testUser = User(
    id: 'u1',
    fullName: 'John Doe',
    email: 'john@example.com',
    phone: '+255712345678',
    nationality: 'Tanzania',
    passportNumber: 'AB1234567',
  );

  setUp(() {
    mockRepo = MockAuthRepository();
    provider = AuthProvider(authRepository: mockRepo);
  });

  group('AuthProvider', () {
    test('initial state is correct', () {
      expect(provider.status, AuthStatus.initial);
      expect(provider.user, isNull);
      expect(provider.errorMessage, isNull);
      expect(provider.isAuthenticated, isFalse);
    });

    group('login', () {
      test('sets authenticated on success', () async {
        when(() => mockRepo.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => testUser);

        await provider.login(email: 'john@example.com', password: 'pass');

        expect(provider.status, AuthStatus.authenticated);
        expect(provider.user, testUser);
        expect(provider.errorMessage, isNull);
        expect(provider.isAuthenticated, isTrue);
      });

      test('sets error on failure', () async {
        when(() => mockRepo.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Invalid credentials'));

        await provider.login(email: 'bad@example.com', password: 'wrong');

        expect(provider.status, AuthStatus.error);
        expect(provider.user, isNull);
        expect(provider.errorMessage, 'Invalid credentials');
        expect(provider.isAuthenticated, isFalse);
      });

      test('sets loading then notifies listeners', () async {
        final statuses = <AuthStatus>[];
        provider.addListener(() => statuses.add(provider.status));

        when(() => mockRepo.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => testUser);

        await provider.login(email: 'john@example.com', password: 'pass');

        expect(statuses, [AuthStatus.loading, AuthStatus.authenticated]);
      });
    });

    group('register', () {
      test('sets authenticated on success', () async {
        when(() => mockRepo.register(
              fullName: any(named: 'fullName'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => testUser);

        await provider.register(
          fullName: 'John Doe',
          email: 'john@example.com',
          password: 'pass',
        );

        expect(provider.status, AuthStatus.authenticated);
        expect(provider.user, testUser);
      });

      test('sets error on failure', () async {
        when(() => mockRepo.register(
              fullName: any(named: 'fullName'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Email taken'));

        await provider.register(
          fullName: 'John Doe',
          email: 'taken@example.com',
          password: 'pass',
        );

        expect(provider.status, AuthStatus.error);
        expect(provider.errorMessage, 'Email taken');
      });
    });

    group('logout', () {
      test('sets unauthenticated on success', () async {
        when(() => mockRepo.logout()).thenAnswer((_) async {});

        await provider.logout();

        expect(provider.status, AuthStatus.unauthenticated);
        expect(provider.user, isNull);
      });

      test('sets error on failure', () async {
        when(() => mockRepo.logout()).thenThrow(Exception('Logout failed'));

        await provider.logout();

        expect(provider.status, AuthStatus.error);
        expect(provider.errorMessage, 'Logout failed');
      });
    });

    group('checkAuthStatus', () {
      test('sets authenticated when logged in with valid user', () async {
        when(() => mockRepo.isLoggedIn()).thenAnswer((_) async => true);
        when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => testUser);

        await provider.checkAuthStatus();

        expect(provider.status, AuthStatus.authenticated);
        expect(provider.user, testUser);
      });

      test('sets unauthenticated when not logged in', () async {
        when(() => mockRepo.isLoggedIn()).thenAnswer((_) async => false);

        await provider.checkAuthStatus();

        expect(provider.status, AuthStatus.unauthenticated);
        expect(provider.user, isNull);
      });

      test('sets unauthenticated when logged in but user is null', () async {
        when(() => mockRepo.isLoggedIn()).thenAnswer((_) async => true);
        when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);

        await provider.checkAuthStatus();

        expect(provider.status, AuthStatus.unauthenticated);
      });

      test('sets unauthenticated on exception', () async {
        when(() => mockRepo.isLoggedIn()).thenThrow(Exception('db error'));

        await provider.checkAuthStatus();

        expect(provider.status, AuthStatus.unauthenticated);
      });
    });

    group('clearError', () {
      test('clears error message', () async {
        when(() => mockRepo.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('bad'));

        await provider.login(email: 'x', password: 'y');
        expect(provider.errorMessage, isNotNull);

        provider.clearError();
        expect(provider.errorMessage, isNull);
      });
    });
  });
}
