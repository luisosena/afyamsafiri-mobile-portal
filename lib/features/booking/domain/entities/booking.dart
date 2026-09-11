enum BookingStatus {
  draft,
  pendingSync,
  submitted,
  cancelled,
}

class SymptomEntry {
  const SymptomEntry({
    required this.name,
    this.value,
  });

  final String name;
  final bool? value;

  SymptomEntry copyWith({bool? value}) {
    return SymptomEntry(
      name: name,
      value: value ?? this.value,
    );
  }
}

class Booking {
  const Booking({
    // Step 1: Entry Details
    this.passportNumber = '',
    this.portOfEntry = '',
    this.arrivalDate,
    // Step 2: Traveler's Information
    this.firstName = '',
    this.middleName = '',
    this.surname = '',
    this.gender = '',
    this.dateOfBirth,
    this.nationality = '',
    // Step 3: Visit & Travel Details
    this.vesselName = '',
    this.seatNumber = '',
    this.purposeOfVisit = '',
    this.durationOfStay = '',
    this.localAddress = '',
    this.hotelName = '',
    this.localPhone = '',
    this.email = '',
    this.journeyStartCountry = '',
    this.countriesVisitedCount = '',
    // Step 4: Health Conditions & Symptoms
    this.symptoms = const [],
    this.additionalSymptoms = '',
    // Step 5: Epidemiological Risk & Declaration
    this.visitedOutbreakArea,
    this.caredForSick,
    this.participatedInBurial,
    this.declarationAccepted = false,
    // Metadata
    this.id,
    this.referenceCode,
    this.status = BookingStatus.draft,
    this.createdAt,
    this.updatedAt,
  });

  // Step 1: Entry Details
  final String passportNumber;
  final String portOfEntry;
  final DateTime? arrivalDate;

  // Step 2: Traveler's Information
  final String firstName;
  final String middleName;
  final String surname;
  final String gender;
  final DateTime? dateOfBirth;
  final String nationality;

  // Step 3: Visit & Travel Details
  final String vesselName;
  final String seatNumber;
  final String purposeOfVisit;
  final String durationOfStay;
  final String localAddress;
  final String hotelName;
  final String localPhone;
  final String email;
  final String journeyStartCountry;
  final String countriesVisitedCount;

  // Step 4: Health Conditions & Symptoms
  final List<SymptomEntry> symptoms;
  final String additionalSymptoms;

  // Step 5: Epidemiological Risk & Declaration
  final bool? visitedOutbreakArea;
  final bool? caredForSick;
  final bool? participatedInBurial;
  final bool declarationAccepted;

  // Metadata
  final String? id;
  final String? referenceCode;
  final BookingStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static const List<String> predefinedSymptoms = [
    'Fever/chills',
    'Swollen glands',
    'Coughing/Shortness breathing',
    'Jaundice',
    'Headache',
    'Chest pain',
    'Unusual bleeding',
    'Difficulty in swallowing',
    'Paralysis',
    'Joint/Muscle pain',
    'Nausea/vomiting',
    'Skin Rash',
    'General Body Weakness',
    'Loss of appetite',
    'Diarrhea',
    'Flu like symptoms',
    'Chills',
  ];

  static List<SymptomEntry> createDefaultSymptoms() {
    return predefinedSymptoms
        .map((name) => SymptomEntry(name: name))
        .toList();
  }

  Booking copyWith({
    String? passportNumber,
    String? portOfEntry,
    DateTime? arrivalDate,
    String? firstName,
    String? middleName,
    String? surname,
    String? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? vesselName,
    String? seatNumber,
    String? purposeOfVisit,
    String? durationOfStay,
    String? localAddress,
    String? hotelName,
    String? localPhone,
    String? email,
    String? journeyStartCountry,
    String? countriesVisitedCount,
    List<SymptomEntry>? symptoms,
    String? additionalSymptoms,
    bool? visitedOutbreakArea,
    bool? caredForSick,
    bool? participatedInBurial,
    bool? declarationAccepted,
    String? id,
    String? referenceCode,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      passportNumber: passportNumber ?? this.passportNumber,
      portOfEntry: portOfEntry ?? this.portOfEntry,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      surname: surname ?? this.surname,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      vesselName: vesselName ?? this.vesselName,
      seatNumber: seatNumber ?? this.seatNumber,
      purposeOfVisit: purposeOfVisit ?? this.purposeOfVisit,
      durationOfStay: durationOfStay ?? this.durationOfStay,
      localAddress: localAddress ?? this.localAddress,
      hotelName: hotelName ?? this.hotelName,
      localPhone: localPhone ?? this.localPhone,
      email: email ?? this.email,
      journeyStartCountry: journeyStartCountry ?? this.journeyStartCountry,
      countriesVisitedCount: countriesVisitedCount ?? this.countriesVisitedCount,
      symptoms: symptoms ?? this.symptoms,
      additionalSymptoms: additionalSymptoms ?? this.additionalSymptoms,
      visitedOutbreakArea: visitedOutbreakArea ?? this.visitedOutbreakArea,
      caredForSick: caredForSick ?? this.caredForSick,
      participatedInBurial: participatedInBurial ?? this.participatedInBurial,
      declarationAccepted: declarationAccepted ?? this.declarationAccepted,
      id: id ?? this.id,
      referenceCode: referenceCode ?? this.referenceCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}