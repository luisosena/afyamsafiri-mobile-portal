import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afyamsafiri/features/profile/domain/entities/profile.dart';
import 'package:afyamsafiri/features/profile/domain/repositories/profile_repository.dart';
import 'package:afyamsafiri/features/profile/presentation/providers/profile_provider.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepo;
  late ProfileProvider provider;

  const testProfile = Profile(
    id: 'u1',
    fullName: 'John Doe',
    phone: '+255712345678',
    nationality: 'Tanzania',
    passportNumber: 'AB1234567',
  );

  setUp(() {
    mockRepo = MockProfileRepository();
    provider = ProfileProvider(profileRepository: mockRepo);
  });

  group('ProfileProvider', () {
    test('initial state is correct', () {
      expect(provider.status, ProfileStatus.initial);
      expect(provider.profile, isNull);
      expect(provider.errorMessage, isNull);
      expect(provider.isEditing, isFalse);
    });

    group('loadProfile', () {
      test('loads profile on success', () async {
        when(() => mockRepo.getProfile()).thenAnswer((_) async => testProfile);

        await provider.loadProfile();

        expect(provider.status, ProfileStatus.loaded);
        expect(provider.profile, testProfile);
      });

      test('sets error on failure', () async {
        when(() => mockRepo.getProfile()).thenThrow(Exception('load failed'));

        await provider.loadProfile();

        expect(provider.status, ProfileStatus.error);
        expect(provider.errorMessage, 'load failed');
      });
    });

    group('updateProfile', () {
      test('updates profile on success', () async {
        final updated = testProfile.copyWith(fullName: 'Jane Doe');
        when(() => mockRepo.updateProfile(
              fullName: any(named: 'fullName'),
            )).thenAnswer((_) async => updated);

        final result = await provider.updateProfile(fullName: 'Jane Doe');

        expect(result, isTrue);
        expect(provider.profile!.fullName, 'Jane Doe');
        expect(provider.status, ProfileStatus.loaded);
        expect(provider.isEditing, isFalse);
      });

      test('returns false on failure', () async {
        when(() => mockRepo.updateProfile(
              fullName: any(named: 'fullName'),
            )).thenThrow(Exception('update failed'));

        final result = await provider.updateProfile(fullName: 'Jane Doe');

        expect(result, isFalse);
        expect(provider.errorMessage, 'update failed');
      });
    });

    group('toggleEditing', () {
      test('toggles editing state', () {
        provider.toggleEditing();
        expect(provider.isEditing, isTrue);

        provider.toggleEditing();
        expect(provider.isEditing, isFalse);
      });

      test('clears error message', () {
        provider.toggleEditing();
        expect(provider.errorMessage, isNull);
      });
    });

    group('cancelEditing', () {
      test('sets editing to false', () {
        provider.toggleEditing();
        provider.cancelEditing();
        expect(provider.isEditing, isFalse);
      });
    });

    group('clearError', () {
      test('clears error message', () async {
        when(() => mockRepo.getProfile()).thenThrow(Exception('err'));

        await provider.loadProfile();
        expect(provider.errorMessage, isNotNull);

        provider.clearError();
        expect(provider.errorMessage, isNull);
      });
    });
  });
}
