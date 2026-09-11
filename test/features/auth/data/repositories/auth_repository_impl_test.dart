import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afyamsafiri/features/auth/data/datasources/auth_datasource.dart';
import 'package:afyamsafiri/features/auth/data/models/auth_response.dart';
import 'package:afyamsafiri/features/auth/data/models/registration_request.dart';
import 'package:afyamsafiri/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late MockAuthDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  const testResponse = AuthResponse(
    userId: 'user-001',
    token: 'test-jwt-token',
    refreshToken: 'test-refresh',
    expiresAt: null,
  );

  const testUserData = {
    'id': 'user-001',
    'fullName': 'John Doe',
    'email': 'john@example.com',
    'phone': '+255712345678',
    'nationality': 'Tanzania',
    'passportNumber': 'AB1234567',
  };

  setUp(() {
    mockDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockDataSource);
    SharedPreferences.setMockInitialValues({});
  });

  setUpAll(() {
    registerFallbackValue(
      RegistrationRequest(
        fullName: '',
        email: '',
        password: '',
      ),
    );
  });

  group('AuthRepositoryImpl', () {
    group('register', () {
      test('returns User and persists token', () async {
        when(() => mockDataSource.register(any()))
            .thenAnswer((_) async => testResponse);

        final user = await repository.register(
          fullName: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          phone: '+255712345678',
          nationality: 'Tanzania',
          passportNumber: 'AB1234567',
        );

        expect(user.id, 'user-001');
        expect(user.fullName, 'John Doe');
        expect(user.email, 'john@example.com');
        expect(user.phone, '+255712345678');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('auth_token'), 'test-jwt-token');
        expect(prefs.getString('user_id'), 'user-001');
      });

      test('propagates datasource errors', () async {
        when(() => mockDataSource.register(any()))
            .thenThrow(Exception('Email taken'));

        expect(
          () => repository.register(
            fullName: 'John',
            email: 'taken@example.com',
            password: 'pass',
          ),
          throwsException,
        );
      });
    });

    group('login', () {
      test('returns User and persists token', () async {
        when(() => mockDataSource.login(any(), any()))
            .thenAnswer((_) async => testResponse);
        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => testUserData);

        final user = await repository.login(
          email: 'john@example.com',
          password: 'password123',
        );

        expect(user.id, 'user-001');
        expect(user.fullName, 'John Doe');
        expect(user.email, 'john@example.com');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('auth_token'), 'test-jwt-token');
        expect(prefs.getString('user_id'), 'user-001');
      });

      test('throws when getCurrentUser returns null after login', () async {
        when(() => mockDataSource.login(any(), any()))
            .thenAnswer((_) async => testResponse);
        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => null);

        expect(
          () => repository.login(email: 'x', password: 'y'),
          throwsA(isA<Exception>()),
        );
      });

      test('propagates datasource login errors', () async {
        when(() => mockDataSource.login(any(), any()))
            .thenThrow(Exception('Invalid credentials'));

        expect(
          () => repository.login(email: 'bad', password: 'creds'),
          throwsException,
        );
      });
    });

    group('logout', () {
      test('calls datasource logout and clears stored tokens', () async {
        SharedPreferences.setMockInitialValues({
          'auth_token': 'old-token',
          'user_id': 'old-user',
        });
        when(() => mockDataSource.logout()).thenAnswer((_) async {});

        await repository.logout();

        verify(() => mockDataSource.logout()).called(1);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('auth_token'), isNull);
        expect(prefs.getString('user_id'), isNull);
      });
    });

    group('isLoggedIn', () {
      test('delegates to datasource', () async {
        when(() => mockDataSource.isLoggedIn()).thenAnswer((_) async => true);

        final result = await repository.isLoggedIn();

        expect(result, isTrue);
        verify(() => mockDataSource.isLoggedIn()).called(1);
      });
    });

    group('getCurrentUser', () {
      test('returns User from datasource data', () async {
        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => testUserData);

        final user = await repository.getCurrentUser();

        expect(user, isNotNull);
        expect(user!.id, 'user-001');
        expect(user.fullName, 'John Doe');
      });

      test('returns null when datasource returns null', () async {
        when(() => mockDataSource.getCurrentUser())
            .thenAnswer((_) async => null);

        final user = await repository.getCurrentUser();

        expect(user, isNull);
      });
    });
  });
}
