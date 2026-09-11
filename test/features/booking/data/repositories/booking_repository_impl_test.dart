import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afyamsafiri/features/booking/data/datasources/booking_datasource.dart';
import 'package:afyamsafiri/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:afyamsafiri/features/booking/domain/entities/booking.dart';

class MockBookingDataSource extends Mock implements BookingDataSource {}

void main() {
  late MockBookingDataSource mockDataSource;
  late BookingRepositoryImpl repository;

  final testBooking = Booking(
    passportNumber: 'AB1234567',
    portOfEntry: 'Julius Nyerere International Airport',
    arrivalDate: DateTime(2026, 9, 15),
    firstName: 'John',
    surname: 'Doe',
    gender: 'Male',
    dateOfBirth: DateTime(1990, 5, 15),
    nationality: 'American',
    purposeOfVisit: 'Tourism',
    localPhone: '+255712345678',
    email: 'john@example.com',
    journeyStartCountry: 'Kenya',
    symptoms: Booking.createDefaultSymptoms(),
  );

  setUp(() {
    mockDataSource = MockBookingDataSource();
    repository = BookingRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('BookingRepositoryImpl', () {
    group('submitBooking', () {
      test('returns booking with id and referenceCode from datasource', () async {
        when(() => mockDataSource.submitBooking(any())).thenAnswer(
          (_) async => {
            'id': 'bk-001',
            'referenceCode': 'TZ-2026-001',
            'status': 'submitted',
            'createdAt': '2026-09-01T10:00:00.000',
            'updatedAt': '2026-09-01T10:00:00.000',
          },
        );

        final result = await repository.submitBooking(testBooking);

        expect(result.id, 'bk-001');
        expect(result.referenceCode, 'TZ-2026-001');
        expect(result.status, BookingStatus.submitted);
        expect(result.createdAt, isNotNull);
      });

      test('propagates datasource errors', () async {
        when(() => mockDataSource.submitBooking(any()))
            .thenThrow(Exception('Server error'));

        expect(
          () => repository.submitBooking(testBooking),
          throwsException,
        );
      });
    });

    group('getBookings', () {
      test('parses datasource response into Booking objects', () async {
        when(() => mockDataSource.getBookings()).thenAnswer(
          (_) async => [
            {
              'id': 'bk-001',
              'referenceCode': 'TZ-2026-001',
              'status': 'submitted',
              'passportNumber': 'AB1234567',
              'portOfEntry': 'Julius Nyerere International Airport',
              'arrivalDate': '2026-09-15T00:00:00.000',
              'firstName': 'John',
              'surname': 'Doe',
              'gender': 'Male',
              'nationality': 'American',
              'vesselName': 'KQ480',
              'purposeOfVisit': 'Tourism',
              'createdAt': '2026-09-01T10:00:00.000',
            },
          ],
        );

        final bookings = await repository.getBookings();

        expect(bookings.length, 1);
        expect(bookings.first.id, 'bk-001');
        expect(bookings.first.status, BookingStatus.submitted);
        expect(bookings.first.firstName, 'John');
        expect(bookings.first.portOfEntry, 'Julius Nyerere International Airport');
      });

      test('handles cancelled status', () async {
        when(() => mockDataSource.getBookings()).thenAnswer(
          (_) async => [
            {'id': 'bk-1', 'status': 'cancelled'},
          ],
        );

        final bookings = await repository.getBookings();

        expect(bookings.first.status, BookingStatus.cancelled);
      });

      test('defaults unknown status to draft', () async {
        when(() => mockDataSource.getBookings()).thenAnswer(
          (_) async => [
            {'id': 'bk-1', 'status': 'unknown'},
          ],
        );

        final bookings = await repository.getBookings();

        expect(bookings.first.status, BookingStatus.draft);
      });
    });

    group('cancelBooking', () {
      test('delegates to datasource', () async {
        when(() => mockDataSource.cancelBooking(any()))
            .thenAnswer((_) async {});

        await repository.cancelBooking('bk-001');

        verify(() => mockDataSource.cancelBooking('bk-001')).called(1);
      });
    });

    group('dropdown methods', () {
      test('getPortsOfEntry delegates to datasource', () async {
        when(() => mockDataSource.getPortsOfEntry())
            .thenAnswer((_) async => ['Port A', 'Port B']);

        final result = await repository.getPortsOfEntry();

        expect(result, ['Port A', 'Port B']);
      });

      test('getNationalities delegates to datasource', () async {
        when(() => mockDataSource.getNationalities())
            .thenAnswer((_) async => ['Tanzanian', 'Kenyan']);

        final result = await repository.getNationalities();

        expect(result, ['Tanzanian', 'Kenyan']);
      });

      test('getCountries delegates to datasource', () async {
        when(() => mockDataSource.getCountries())
            .thenAnswer((_) async => ['Tanzania', 'Kenya']);

        final result = await repository.getCountries();

        expect(result, ['Tanzania', 'Kenya']);
      });

      test('getPurposesOfVisit delegates to datasource', () async {
        when(() => mockDataSource.getPurposesOfVisit())
            .thenAnswer((_) async => ['Tourism', 'Business']);

        final result = await repository.getPurposesOfVisit();

        expect(result, ['Tourism', 'Business']);
      });
    });
  });
}
