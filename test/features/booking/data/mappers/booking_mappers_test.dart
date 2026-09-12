import 'package:flutter_test/flutter_test.dart';
import 'package:afyamsafiri/features/booking/data/mappers/booking_mappers.dart';
import 'package:afyamsafiri/features/booking/domain/entities/booking.dart';
import 'package:afyamsafiri/core/constants/dhis2_ids.dart';

Booking createTestBooking({
  String? id = 'bk-001',
  String firstName = 'John',
  String middleName = 'Michael',
  String surname = 'Doe',
  String gender = 'Male',
  DateTime? dateOfBirth,
  String nationality = 'American',
  String vesselName = 'KQ480',
  String seatNumber = '12A',
  String purposeOfVisit = 'Tourism',
  String durationOfStay = '7',
  String localAddress = '123 Street',
  String hotelName = 'Hilton',
  String localPhone = '+255712345678',
  String email = 'john@example.com',
  String journeyStartCountry = 'Kenya',
  String countriesVisitedCount = '2',
  DateTime? arrivalDate,
  bool declarationAccepted = true,
  bool? visitedOutbreakArea = false,
  bool? caredForSick = false,
  bool? participatedInBurial = false,
}) {
  return Booking(
    id: id,
    firstName: firstName,
    middleName: middleName,
    surname: surname,
    gender: gender,
    dateOfBirth: dateOfBirth ?? DateTime(1990, 5, 15),
    nationality: nationality,
    vesselName: vesselName,
    seatNumber: seatNumber,
    purposeOfVisit: purposeOfVisit,
    durationOfStay: durationOfStay,
    localAddress: localAddress,
    hotelName: hotelName,
    localPhone: localPhone,
    email: email,
    journeyStartCountry: journeyStartCountry,
    countriesVisitedCount: countriesVisitedCount,
    arrivalDate: arrivalDate ?? DateTime(2026, 9, 15),
    declarationAccepted: declarationAccepted,
    visitedOutbreakArea: visitedOutbreakArea,
    caredForSick: caredForSick,
    participatedInBurial: participatedInBurial,
    symptoms: [
      const SymptomEntry(name: 'Fever/chills', value: true),
      const SymptomEntry(name: 'Headache', value: false),
    ],
    additionalSymptoms: 'None',
  );
}

void main() {
  group('booking_mappers', () {
    group('mapBookingToTEI', () {
      test('creates TEI with correct id and orgUnit', () {
        final booking = createTestBooking();

        final tei = mapBookingToTEI(
          booking: booking,
          trackedEntityType: 'TET-1',
          orgUnit: 'OU-1',
        );

        expect(tei.id, 'bk-001');
        expect(tei.trackedEntityInstance, 'bk-001');
        expect(tei.orgUnit, 'OU-1');
        expect(tei.trackedEntityType, 'TET-1');
      });

      test('marks TEI as dirty and not synced', () {
        final booking = createTestBooking();

        final tei = mapBookingToTEI(
          booking: booking,
          trackedEntityType: 'TET-1',
          orgUnit: 'OU-1',
        );

        expect(tei.dirty, true);
        expect(tei.synced, false);
      });

      test('generates UUID when booking id is null', () {
        final booking = createTestBooking(id: null);

        final tei = mapBookingToTEI(
          booking: booking,
          trackedEntityType: 'TET-1',
          orgUnit: 'OU-1',
        );

        expect(tei.id, isNotEmpty);
        expect(tei.id, isNot('null'));
      });

      test('maps all 16 attribute fields', () {
        final booking = createTestBooking();

        final tei = mapBookingToTEI(
          booking: booking,
          trackedEntityType: 'TET-1',
          orgUnit: 'OU-1',
        );

        expect(tei.attributes!.length, 16);

        final attrIds = tei.attributes!.map((a) => a.attribute).toSet();
        expect(attrIds, contains(DHIS2IDs.firstNameAttr));
        expect(attrIds, contains(DHIS2IDs.middleNameAttr));
        expect(attrIds, contains(DHIS2IDs.surnameAttr));
        expect(attrIds, contains(DHIS2IDs.genderAttr));
        expect(attrIds, contains(DHIS2IDs.dateOfBirthAttr));
        expect(attrIds, contains(DHIS2IDs.nationalityAttr));
        expect(attrIds, contains(DHIS2IDs.vesselNameAttr));
        expect(attrIds, contains(DHIS2IDs.seatNumberAttr));
        expect(attrIds, contains(DHIS2IDs.visitingPurposeAttr));
        expect(attrIds, contains(DHIS2IDs.durationOfStayTzAttr));
        expect(attrIds, contains(DHIS2IDs.physicalAddressAttr));
        expect(attrIds, contains(DHIS2IDs.hotelNameAttr));
        expect(attrIds, contains(DHIS2IDs.phoneNumberAttr));
        expect(attrIds, contains(DHIS2IDs.emailAttr));
        expect(attrIds, contains(DHIS2IDs.countryJourneyStartedAttr));
        expect(attrIds, contains(DHIS2IDs.countriesVisitedCountAttr));
      });

      test('attribute values match booking fields', () {
        final booking = createTestBooking();

        final tei = mapBookingToTEI(
          booking: booking,
          trackedEntityType: 'TET-1',
          orgUnit: 'OU-1',
        );

        final attrMap = {
          for (final a in tei.attributes!) a.attribute: a.value,
        };
        expect(attrMap[DHIS2IDs.firstNameAttr], 'John');
        expect(attrMap[DHIS2IDs.surnameAttr], 'Doe');
        expect(attrMap[DHIS2IDs.genderAttr], 'Male');
        expect(attrMap[DHIS2IDs.nationalityAttr], 'American');
        expect(attrMap[DHIS2IDs.vesselNameAttr], 'KQ480');
      });

      test('dateOfBirth is formatted as yyyy-MM-dd', () {
        final booking = createTestBooking(dateOfBirth: DateTime(1990, 5, 15));

        final tei = mapBookingToTEI(
          booking: booking,
          trackedEntityType: 'TET-1',
          orgUnit: 'OU-1',
        );

        final dobAttr = tei.attributes!.firstWhere(
          (a) => a.attribute == DHIS2IDs.dateOfBirthAttr,
        );
        expect(dobAttr.value, '1990-05-15');
      });

      test('creates enrollment with unique id', () {
        final booking = createTestBooking();

        final tei = mapBookingToTEI(
          booking: booking,
          trackedEntityType: 'TET-1',
          orgUnit: 'OU-1',
        );

        expect(tei.enrollments, isNotNull);
        expect(tei.enrollments!.length, 1);

        final enrollment = tei.enrollments!.first;
        expect(enrollment.trackedEntityInstance, 'bk-001');
        expect(enrollment.trackedEntityType, 'TET-1');
        expect(enrollment.orgUnit, 'OU-1');
        expect(enrollment.program, DHIS2IDs.program);
        expect(enrollment.status, 'ACTIVE');
        expect(enrollment.dirty, true);
        expect(enrollment.id, isNot('bk-001'));
        expect(enrollment.id, isNotEmpty);
      });
    });

    group('mapBookingToTravelHistoryEvent', () {
      test('creates event with correct stage and TEI reference', () {
        final booking = createTestBooking();

        final event = mapBookingToTravelHistoryEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        expect(event.programStage, DHIS2IDs.travelHistoryStage);
        expect(event.trackedEntityInstance, 'bk-001');
        expect(event.enrollment, 'enr-001');
        expect(event.orgUnit, 'OU-1');
      });

      test('marks event as dirty and not synced', () {
        final booking = createTestBooking();

        final event = mapBookingToTravelHistoryEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        expect(event.dirty, true);
        expect(event.synced, false);
        expect(event.status, 'ACTIVE');
      });

      test('event date uses arrival date', () {
        final booking = createTestBooking(arrivalDate: DateTime(2026, 10, 1));

        final event = mapBookingToTravelHistoryEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        expect(event.eventDate, '2026-10-01');
      });

      test('event date falls back to today when arrival date is null', () {
        final booking = createTestBooking();
        final bookingWithoutDate = Booking(
          arrivalDate: null,
          firstName: booking.firstName,
          surname: booking.surname,
          symptoms: booking.symptoms,
        );

        final event = mapBookingToTravelHistoryEvent(
          booking: bookingWithoutDate,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        final today = DateTime.now().toIso8601String().split('T').first;
        expect(event.eventDate, today);
      });

      test('has 4 data values for travel history', () {
        final booking = createTestBooking();

        final event = mapBookingToTravelHistoryEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        expect(event.dataValues!.length, 4);
        final deIds = event.dataValues!.map((dv) => dv.dataElement).toSet();
        expect(deIds, contains(DHIS2IDs.countryVisitedDE));
        expect(deIds, contains(DHIS2IDs.provinceDE));
        expect(deIds, contains(DHIS2IDs.dateOfVisitCountryDE));
        expect(deIds, contains(DHIS2IDs.numberDaysCountryVisitDE));
      });
    });

    group('mapBookingToHealthDeclarationEvent', () {
      test('creates event with correct stage', () {
        final booking = createTestBooking();

        final event = mapBookingToHealthDeclarationEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        expect(event.programStage, DHIS2IDs.healthDeclarationStage);
        expect(event.trackedEntityInstance, 'bk-001');
        expect(event.enrollment, 'enr-001');
      });

      test('maps symptoms with true values', () {
        final booking = createTestBooking();

        final event = mapBookingToHealthDeclarationEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        final dvMap = {
          for (final dv in event.dataValues!) dv.dataElement: dv.value,
        };
        expect(dvMap[DHIS2IDs.symptmFeverDE], 'true');
      });

      test('maps symptoms with false values', () {
        final booking = createTestBooking();

        final event = mapBookingToHealthDeclarationEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        final dvMap = {
          for (final dv in event.dataValues!) dv.dataElement: dv.value,
        };
        expect(dvMap[DHIS2IDs.sympHeadacheDE], 'false');
      });

      test('maps other symptoms text field', () {
        final booking = createTestBooking();

        final event = mapBookingToHealthDeclarationEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        final dvMap = {
          for (final dv in event.dataValues!) dv.dataElement: dv.value,
        };
        expect(dvMap[DHIS2IDs.otherSymptomsDE], 'None');
      });

      test('maps exposure fields as boolean strings', () {
        final booking = createTestBooking(
          visitedOutbreakArea: true,
          caredForSick: false,
          participatedInBurial: true,
        );

        final event = mapBookingToHealthDeclarationEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        final dvMap = {
          for (final dv in event.dataValues!) dv.dataElement: dv.value,
        };
        expect(dvMap[DHIS2IDs.exposureVisitedOutbreakAreaDE], 'true');
        expect(dvMap[DHIS2IDs.exposureCareForSickDE], 'false');
        expect(dvMap[DHIS2IDs.exposureParticipateBurialDE], 'true');
      });

      test('maps declaration accepted as true', () {
        final booking = createTestBooking(declarationAccepted: true);

        final event = mapBookingToHealthDeclarationEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        final dvMap = {
          for (final dv in event.dataValues!) dv.dataElement: dv.value,
        };
        expect(dvMap[DHIS2IDs.declareTsfDE], 'true');
      });

      test('data values count includes symptoms + other + exposure + declaration', () {
        final booking = createTestBooking();

        final event = mapBookingToHealthDeclarationEvent(
          booking: booking,
          teiId: 'bk-001',
          enrollmentId: 'enr-001',
          orgUnit: 'OU-1',
        );

        // 2 matched symptoms + otherSymptoms + 3 exposure + declaration = 7
        expect(event.dataValues!.length, 7);
      });
    });
  });
}
