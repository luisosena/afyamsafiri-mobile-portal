import 'package:d2_touch/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/tracked_entity_attribute_value.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/enrollment.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/event.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/event_data_value.entity.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/dhis2_ids.dart';
import '../../domain/entities/booking.dart';

const _uuid = Uuid();

TrackedEntityInstance mapBookingToTEI({
  required Booking booking,
  required String trackedEntityType,
  required String orgUnit,
}) {
  final teiId = booking.id ?? _uuid.v4();

  final attributes = <TrackedEntityAttributeValue>[
    _attr(teiId, DHIS2IDs.firstNameAttr, booking.firstName),
    _attr(teiId, DHIS2IDs.middleNameAttr, booking.middleName),
    _attr(teiId, DHIS2IDs.surnameAttr, booking.surname),
    _attr(teiId, DHIS2IDs.genderAttr, booking.gender),
    _attr(teiId, DHIS2IDs.dateOfBirthAttr,
        booking.dateOfBirth?.toIso8601String().split('T').first ?? ''),
    _attr(teiId, DHIS2IDs.nationalityAttr, booking.nationality),
    _attr(teiId, DHIS2IDs.vesselNameAttr, booking.vesselName),
    _attr(teiId, DHIS2IDs.seatNumberAttr, booking.seatNumber),
    _attr(teiId, DHIS2IDs.visitingPurposeAttr, booking.purposeOfVisit),
    _attr(teiId, DHIS2IDs.durationOfStayTzAttr, booking.durationOfStay),
    _attr(teiId, DHIS2IDs.physicalAddressAttr, booking.localAddress),
    _attr(teiId, DHIS2IDs.hotelNameAttr, booking.hotelName),
    _attr(teiId, DHIS2IDs.phoneNumberAttr, booking.localPhone),
    _attr(teiId, DHIS2IDs.emailAttr, booking.email),
    _attr(teiId, DHIS2IDs.countryJourneyStartedAttr,
        booking.journeyStartCountry),
    _attr(teiId, DHIS2IDs.countriesVisitedCountAttr,
        booking.countriesVisitedCount),
  ];

  final now = DateTime.now().toIso8601String();

  final enrollment = Enrollment(
    id: _uuid.v4(),
    trackedEntityInstance: teiId,
    trackedEntityType: trackedEntityType,
    orgUnit: orgUnit,
    program: DHIS2IDs.program,
    status: 'ACTIVE',
    dirty: true,
  );

  return TrackedEntityInstance(
    id: teiId,
    trackedEntityInstance: teiId,
    orgUnit: orgUnit,
    trackedEntityType: trackedEntityType,
    dirty: true,
    synced: false,
    attributes: attributes,
    enrollments: [enrollment],
    created: now,
    lastUpdated: now,
  );
}

Event mapBookingToTravelHistoryEvent({
  required Booking booking,
  required String teiId,
  required String enrollmentId,
  required String orgUnit,
}) {
  final eventId = _uuid.v4();
  final eventDate = booking.arrivalDate?.toIso8601String().split('T').first ??
      DateTime.now().toIso8601String().split('T').first;

  // TODO(C6): populate from booking.countriesVisited once repeatable sections are implemented
  final dataValues = <EventDataValue>[
    _dv(eventId, DHIS2IDs.countryVisitedDE, ''),
    _dv(eventId, DHIS2IDs.provinceDE, ''),
    _dv(eventId, DHIS2IDs.dateOfVisitCountryDE, ''),
    _dv(eventId, DHIS2IDs.numberDaysCountryVisitDE, ''),
  ];

  return Event(
    id: eventId,
    event: eventId,
    orgUnit: orgUnit,
    status: 'ACTIVE',
    dirty: true,
    synced: false,
    eventDate: eventDate,
    programStage: DHIS2IDs.travelHistoryStage,
    trackedEntityInstance: teiId,
    enrollment: enrollmentId,
    dataValues: dataValues,
  );
}

Event mapBookingToHealthDeclarationEvent({
  required Booking booking,
  required String teiId,
  required String enrollmentId,
  required String orgUnit,
}) {
  final eventId = _uuid.v4();
  final eventDate = booking.arrivalDate?.toIso8601String().split('T').first ??
      DateTime.now().toIso8601String().split('T').first;

  final symptomDEs = {
    'Fever/chills': DHIS2IDs.symptmFeverDE,
    'Joint/Muscle pain': DHIS2IDs.sympMusclePainDE,
    'Swollen glands': DHIS2IDs.sympSwollenGlandsDE,
    'Nausea/vomiting': DHIS2IDs.sympVomitingDE,
    'Coughing/Shortness breathing': DHIS2IDs.sympDifficultBreathingDE,
    'Skin Rash': DHIS2IDs.sympSkinRashDE,
    'Jaundice': DHIS2IDs.sympJaundiceDE,
    'General Body Weakness': DHIS2IDs.sympBodyWeaknessDE,
    'Headache': DHIS2IDs.sympHeadacheDE,
    'Loss of appetite': DHIS2IDs.sympLossAppetiteDE,
    'Chest pain': DHIS2IDs.sympChestPainDE,
    'Diarrhea': DHIS2IDs.sympDiarrheaDE,
    'Unusual bleeding': DHIS2IDs.sympUnusualBleedingDE,
    'Flu like symptoms': DHIS2IDs.sympFluDE,
    'Difficulty in swallowing': DHIS2IDs.sympDifficultSwallowingDE,
    'Chills': DHIS2IDs.sympChillsDE,
    'Paralysis': DHIS2IDs.sympParalysisDE,
  };

  final dataValues = <EventDataValue>[];

  for (final symptom in booking.symptoms) {
    final deId = symptomDEs[symptom.name];
    if (deId != null) {
      dataValues.add(_dv(eventId, deId, symptom.value == true ? 'true' : 'false'));
    }
  }

  dataValues.add(_dv(eventId, DHIS2IDs.otherSymptomsDE, booking.additionalSymptoms));
  dataValues.add(_dv(eventId, DHIS2IDs.exposureVisitedOutbreakAreaDE,
      booking.visitedOutbreakArea == true ? 'true' : 'false'));
  dataValues.add(_dv(eventId, DHIS2IDs.exposureCareForSickDE,
      booking.caredForSick == true ? 'true' : 'false'));
  dataValues.add(_dv(eventId, DHIS2IDs.exposureParticipateBurialDE,
      booking.participatedInBurial == true ? 'true' : 'false'));
  dataValues.add(_dv(eventId, DHIS2IDs.declareTsfDE,
      booking.declarationAccepted ? 'true' : 'false'));

  return Event(
    id: eventId,
    event: eventId,
    orgUnit: orgUnit,
    status: 'ACTIVE',
    dirty: true,
    synced: false,
    eventDate: eventDate,
    programStage: DHIS2IDs.healthDeclarationStage,
    trackedEntityInstance: teiId,
    enrollment: enrollmentId,
    dataValues: dataValues,
  );
}

TrackedEntityAttributeValue _attr(
    String teiId, String attributeId, String value) {
  return TrackedEntityAttributeValue(
    id: '${teiId}_$attributeId',
    name: '${teiId}_$attributeId',
    attribute: attributeId,
    value: value,
    trackedEntityInstance: teiId,
    dirty: true,
  );
}

EventDataValue _dv(String eventId, String dataElementId, String value) {
  return EventDataValue(
    id: '${eventId}_$dataElementId',
    name: '${eventId}_$dataElementId',
    dataElement: dataElementId,
    value: value,
    event: eventId,
    dirty: true,
  );
}
