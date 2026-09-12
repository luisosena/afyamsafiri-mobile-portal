import 'package:flutter_test/flutter_test.dart';
import 'package:d2_touch/modules/auth/entities/user.entity.dart';
import 'package:afyamsafiri/features/auth/data/mappers/auth_mappers.dart';

User createTestUser({
  String id = 'user-1',
  String firstName = 'John',
  String surname = 'Doe',
  String token = 'test-token',
  String? refreshToken = 'refresh-123',
  String? tokenExpiresAt = '2026-12-31T23:59:59.000',
  String? phoneNumber = '+255712345678',
  String? gender = 'Male',
}) {
  return User(
    id: id,
    firstName: firstName,
    surname: surname,
    name: '$firstName $surname',
    baseUrl: 'https://play.dhis2.org',
    token: token,
    refreshToken: refreshToken,
    tokenExpiresAt: tokenExpiresAt,
    phoneNumber: phoneNumber,
    gender: gender,
    isLoggedIn: true,
    dirty: false,
  );
}

void main() {
  group('auth_mappers', () {
    group('mapD2UserToAuthResponse', () {
      test('maps token and user id correctly', () {
        final user = createTestUser();

        final response = mapD2UserToAuthResponse(user);

        expect(response.userId, 'user-1');
        expect(response.token, 'test-token');
        expect(response.refreshToken, 'refresh-123');
      });

      test('parses tokenExpiresAt to DateTime', () {
        final user = createTestUser(
          tokenExpiresAt: '2026-12-31T23:59:59.000',
        );

        final response = mapD2UserToAuthResponse(user);

        expect(response.expiresAt, isNotNull);
        expect(response.expiresAt!.year, 2026);
        expect(response.expiresAt!.month, 12);
      });

      test('handles null tokenExpiresAt', () {
        final user = createTestUser(tokenExpiresAt: null);

        final response = mapD2UserToAuthResponse(user);

        expect(response.expiresAt, isNull);
      });

      test('handles empty id and token', () {
        final user = User(
          id: '',
          firstName: 'John',
          surname: 'Doe',
          name: 'John Doe',
          baseUrl: 'https://play.dhis2.org',
          token: null,
          isLoggedIn: true,
          dirty: false,
        );

        final response = mapD2UserToAuthResponse(user);

        expect(response.userId, '');
        expect(response.token, '');
      });
    });

    group('mapD2UserToCurrentUser', () {
      test('maps user fields to current user map', () {
        final user = createTestUser();

        final result = mapD2UserToCurrentUser(user);

        expect(result['id'], 'user-1');
        expect(result['fullName'], 'John Doe');
        expect(result['email'], '');
        expect(result['phone'], '+255712345678');
        expect(result['gender'], 'Male');
      });

      test('trims fullName when surname is null', () {
        final user = User(
          id: 'u1',
          firstName: 'John',
          surname: null,
          name: 'John',
          baseUrl: 'https://play.dhis2.org',
          isLoggedIn: true,
          dirty: false,
        );

        final result = mapD2UserToCurrentUser(user);

        expect(result['fullName'], 'John');
      });

      test('email is always empty string', () {
        final user = createTestUser();

        final result = mapD2UserToCurrentUser(user);

        expect(result['email'], '');
      });
    });
  });
}
