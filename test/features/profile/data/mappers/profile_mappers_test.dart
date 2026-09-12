import 'package:flutter_test/flutter_test.dart';
import 'package:d2_touch/modules/auth/entities/user.entity.dart';
import 'package:afyamsafiri/features/profile/data/mappers/profile_mappers.dart';

User createTestUser({
  String id = 'user-1',
  String firstName = 'John',
  String surname = 'Doe',
  String? phoneNumber = '+255712345678',
}) {
  return User(
    id: id,
    firstName: firstName,
    surname: surname,
    name: '$firstName $surname',
    baseUrl: 'https://play.dhis2.org',
    phoneNumber: phoneNumber,
    isLoggedIn: true,
    dirty: false,
  );
}

void main() {
  group('profile_mappers', () {
    group('mapD2UserToProfile', () {
      test('maps user fields to Profile', () {
        final user = createTestUser();

        final profile = mapD2UserToProfile(user);

        expect(profile.id, 'user-1');
        expect(profile.fullName, 'John Doe');
        expect(profile.phone, '+255712345678');
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

        final profile = mapD2UserToProfile(user);

        expect(profile.fullName, 'John');
      });

      test('handles null phone', () {
        final user = createTestUser(phoneNumber: null);

        final profile = mapD2UserToProfile(user);

        expect(profile.phone, isNull);
      });

      test('handles empty id', () {
        final user = User(
          id: '',
          firstName: 'John',
          surname: 'Doe',
          name: 'John Doe',
          baseUrl: 'https://play.dhis2.org',
          isLoggedIn: true,
          dirty: false,
        );

        final profile = mapD2UserToProfile(user);

        expect(profile.id, '');
      });
    });
  });
}
