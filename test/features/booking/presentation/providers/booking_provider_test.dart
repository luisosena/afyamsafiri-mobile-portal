import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afyamsafiri/features/booking/domain/entities/booking.dart';
import 'package:afyamsafiri/features/booking/domain/repositories/booking_repository.dart';
import 'package:afyamsafiri/features/booking/presentation/providers/booking_provider.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late MockBookingRepository mockRepo;
  late BookingProvider provider;

  final testBooking = Booking(
    id: 'bk-1',
    referenceCode: 'TZ-2026-001',
    status: BookingStatus.submitted,
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
    createdAt: DateTime(2026, 9, 1),
    updatedAt: DateTime(2026, 9, 1),
  );

  setUp(() {
    mockRepo = MockBookingRepository();
    provider = BookingProvider(bookingRepository: mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(Booking(symptoms: Booking.createDefaultSymptoms()));
  });

  group('BookingProvider', () {
    test('initial state is correct', () {
      expect(provider.currentStatus, BookingSubmitStatus.initial);
      expect(provider.listStatus, BookingListStatus.initial);
      expect(provider.bookings, isEmpty);
      expect(provider.errorMessage, isNull);
      expect(provider.booking.passportNumber, '');
      expect(provider.booking.symptoms.length, Booking.predefinedSymptoms.length);
    });

    group('step setters', () {
      test('setPassportNumber updates booking', () {
        provider.setPassportNumber('XY999999');
        expect(provider.booking.passportNumber, 'XY999999');
      });

      test('setPortOfEntry updates booking', () {
        provider.setPortOfEntry('Kilimanjaro International Airport');
        expect(provider.booking.portOfEntry, 'Kilimanjaro International Airport');
      });

      test('setArrivalDate updates booking', () {
        final date = DateTime(2026, 12, 25);
        provider.setArrivalDate(date);
        expect(provider.booking.arrivalDate, date);
      });

      test('setFirstName updates booking', () {
        provider.setFirstName('Jane');
        expect(provider.booking.firstName, 'Jane');
      });

      test('setSurname updates booking', () {
        provider.setSurname('Smith');
        expect(provider.booking.surname, 'Smith');
      });

      test('setGender updates booking', () {
        provider.setGender('Female');
        expect(provider.booking.gender, 'Female');
      });

      test('setNationality updates booking', () {
        provider.setNationality('Kenyan');
        expect(provider.booking.nationality, 'Kenyan');
      });

      test('setSymptomValue updates specific symptom', () {
        provider.setSymptomValue(0, true);
        expect(provider.booking.symptoms[0].value, isTrue);
        expect(provider.booking.symptoms[1].value, isNull);
      });

      test('setVisitedOutbreakArea updates booking', () {
        provider.setVisitedOutbreakArea(true);
        expect(provider.booking.visitedOutbreakArea, isTrue);
      });

      test('setDeclarationAccepted updates booking', () {
        provider.setDeclarationAccepted(true);
        expect(provider.booking.declarationAccepted, isTrue);
      });
    });

    group('step validation', () {
      test('step 1 invalid when empty', () {
        expect(provider.isStep1Valid, isFalse);
      });

      test('step 1 valid when all fields set', () {
        provider.setPassportNumber('AB123');
        provider.setPortOfEntry('Dar es Salaam Port');
        provider.setArrivalDate(DateTime(2026, 10, 1));
        expect(provider.isStep1Valid, isTrue);
      });

      test('step 2 invalid when empty', () {
        expect(provider.isStep2Valid, isFalse);
      });

      test('step 2 valid when all required fields set', () {
        provider.setFirstName('John');
        provider.setSurname('Doe');
        provider.setGender('Male');
        provider.setDateOfBirth(DateTime(1990, 1, 1));
        provider.setNationality('Tanzanian');
        expect(provider.isStep2Valid, isTrue);
      });

      test('step 4 valid when all symptoms have values', () {
        for (var i = 0; i < Booking.predefinedSymptoms.length; i++) {
          provider.setSymptomValue(i, false);
        }
        expect(provider.isStep4Valid, isTrue);
      });

      test('step 5 valid when all fields set', () {
        provider.setVisitedOutbreakArea(false);
        provider.setCaredForSick(false);
        provider.setParticipatedInBurial(false);
        provider.setDeclarationAccepted(true);
        expect(provider.isStep5Valid, isTrue);
      });

      test('isStepValid returns false for invalid step index', () {
        expect(provider.isStepValid(99), isFalse);
      });
    });

    group('submit', () {
      test('sets success on successful submission', () async {
        when(() => mockRepo.submitBooking(any()))
            .thenAnswer((_) async => testBooking);

        final result = await provider.submit();

        expect(result, isTrue);
        expect(provider.currentStatus, BookingSubmitStatus.success);
        expect(provider.referenceCode, 'TZ-2026-001');
      });

      test('sets error on failed submission', () async {
        when(() => mockRepo.submitBooking(any()))
            .thenThrow(Exception('Network error'));

        final result = await provider.submit();

        expect(result, isFalse);
        expect(provider.currentStatus, BookingSubmitStatus.error);
        expect(provider.errorMessage, 'Network error');
      });
    });

    group('loadBookings', () {
      test('loads bookings successfully', () async {
        when(() => mockRepo.getBookings()).thenAnswer((_) async => [testBooking]);

        await provider.loadBookings();

        expect(provider.listStatus, BookingListStatus.loaded);
        expect(provider.bookings, [testBooking]);
      });

      test('sets error on failure', () async {
        when(() => mockRepo.getBookings()).thenThrow(Exception('db error'));

        await provider.loadBookings();

        expect(provider.listStatus, BookingListStatus.error);
        expect(provider.errorMessage, 'db error');
      });
    });

    group('cancelBooking', () {
      test('updates booking status to cancelled', () async {
        when(() => mockRepo.getBookings()).thenAnswer((_) async => [testBooking]);
        when(() => mockRepo.cancelBooking(any())).thenAnswer((_) async {});

        await provider.loadBookings();
        await provider.cancelBooking('bk-1');

        expect(provider.bookings.first.status, BookingStatus.cancelled);
      });

      test('sets error on cancel failure', () async {
        when(() => mockRepo.getBookings()).thenAnswer((_) async => [testBooking]);
        when(() => mockRepo.cancelBooking(any())).thenThrow(Exception('cancel error'));

        await provider.loadBookings();
        await provider.cancelBooking('bk-1');

        expect(provider.errorMessage, 'cancel error');
      });
    });

    group('dropdown data', () {
      test('loadPortsOfEntry populates list', () async {
        when(() => mockRepo.getPortsOfEntry())
            .thenAnswer((_) async => ['Dar es Salaam Port', 'Kilimanjaro Airport']);

        await provider.loadPortsOfEntry();

        expect(provider.portsOfEntry, ['Dar es Salaam Port', 'Kilimanjaro Airport']);
      });

      test('loadNationalities populates list', () async {
        when(() => mockRepo.getNationalities())
            .thenAnswer((_) async => ['Tanzanian', 'Kenyan']);

        await provider.loadNationalities();

        expect(provider.nationalities, ['Tanzanian', 'Kenyan']);
      });

      test('loadCountries populates list', () async {
        when(() => mockRepo.getCountries())
            .thenAnswer((_) async => ['Tanzania', 'Kenya']);

        await provider.loadCountries();

        expect(provider.countries, ['Tanzania', 'Kenya']);
      });

      test('loadPurposesOfVisit populates list', () async {
        when(() => mockRepo.getPurposesOfVisit())
            .thenAnswer((_) async => ['Tourism', 'Business']);

        await provider.loadPurposesOfVisit();

        expect(provider.purposesOfVisit, ['Tourism', 'Business']);
      });

      test('dropdown errors are swallowed gracefully', () async {
        when(() => mockRepo.getPortsOfEntry()).thenThrow(Exception('fail'));

        await provider.loadPortsOfEntry();

        expect(provider.portsOfEntry, isEmpty);
      });
    });

    group('reset', () {
      test('resets to initial state', () {
        provider.setPassportNumber('XY999');
        provider.setFirstName('Jane');

        provider.reset();

        expect(provider.currentStatus, BookingSubmitStatus.initial);
        expect(provider.errorMessage, isNull);
        expect(provider.referenceCode, isNull);
        expect(provider.booking.passportNumber, '');
        expect(provider.booking.firstName, '');
      });
    });
  });
}
