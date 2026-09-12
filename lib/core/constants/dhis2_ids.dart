class DHIS2IDs {
  DHIS2IDs._();

  // Program
  static const String program = 'rDlK50Tc8rt';

  // Program Stages
  static const String travelHistoryStage = 'as8achp5xJ6';
  static const String healthDeclarationStage = 'Sn3kSLdUY36';

  // Tracked Entity Type — TODO: get from supervisor or query DHIS2 /programs/{id}
  static const String trackedEntityType = 'TODO';

  // Organisation Units — TODO: get from supervisor
  // static const String juliusNyerereAirport = 'xxx';

  // ATTRIBUTE IDs (person-level, on TrackedEntityInstance)
  // personal_details
  static const String firstNameAttr = 'rLh3jEH2vNa';
  static const String middleNameAttr = 'qvKJ87n7bz5';
  static const String surnameAttr = 'ENRjVGxVL6l';

  // nationality_gender_details
  static const String genderAttr = 'oindugucx72';
  static const String dateOfBirthAttr = 'NI0QRzJvQ0k';
  static const String nationalityAttr = 'GqZ0ajzb0SF';

  // arrival_details
  static const String vesselNameAttr = 'VO6yOcpsgvc';
  static const String seatNumberAttr = 'BlCTwevCKFD';

  // visit_purpose_details
  static const String visitingPurposeAttr = 'zyC7l0mhZte';
  // TODO(C6): map to booking when otherVisitingPurpose field is added to Booking entity
  static const String otherVisitingPurposeAttr = 'qiB2CZOGnq0';
  static const String durationOfStayTzAttr = 'xecQx9mtG7K';

  // physical_contact_in_tanzania
  static const String physicalAddressAttr = 'uqd4TLieMyV';
  static const String hotelNameAttr = 'Pnc4KE1NbiV';

  // contact_in_tanzania
  static const String phoneNumberAttr = 'gNkLFyRTjpw';
  static const String emailAttr = 'P14fDzABGbR';

  // travel_history
  static const String countryJourneyStartedAttr = 'c0lAgxOeymb';

  // departure_details
  static const String countriesVisitedCountAttr = 'lHMYu9Te83R';

  // DATA ELEMENT IDs — Travel History stage (as8achp5xJ6), repeatable (countries_visited)
  static const String countryVisitedDE = 'w4GGpmEEUHc';
  static const String provinceDE = 'J3bf9ppqRr9';
  static const String dateOfVisitCountryDE = 'S1aglLTHAHs';
  static const String numberDaysCountryVisitDE = 'NEgmzir4zs7';

  // DATA ELEMENT IDs — Health & Declaration stage (Sn3kSLdUY36)
  // health_conditions (17 symptom fields)
  static const String symptmFeverDE = 'EWZcuvPOrJF';
  static const String sympMusclePainDE = 'Ya67RKSChtf';
  static const String sympSwollenGlandsDE = 'ChHn5nykxXI';
  static const String sympVomitingDE = 'qcRlAy9MStY';
  static const String sympDifficultBreathingDE = 'fyzp8BpsPMl';
  static const String sympSkinRashDE = 'SeKu9WMNh16';
  static const String sympJaundiceDE = 'JawhrWlrehx';
  static const String sympBodyWeaknessDE = 'yOScHb5cBN3';
  static const String sympHeadacheDE = 'cYI3B3KwLX5';
  static const String sympLossAppetiteDE = 'piVmaq1hr2k';
  static const String sympChestPainDE = 'HahhmzRvwu8';
  static const String sympDiarrheaDE = 'IrFWIj5ks2p';
  static const String sympUnusualBleedingDE = 'tEeXlLZAx9W';
  static const String sympFluDE = 'diAKanXKJG3';
  static const String sympDifficultSwallowingDE = 'qZMQ7x3S2CZ';
  static const String sympChillsDE = 'rhgMIm9UX2Z';
  static const String sympParalysisDE = 'nBJPMl3Aqsb';

  // other_health_conditions
  static const String otherSymptomsDE = 'wzsQWMhoKwM';

  // exposure
  static const String exposureVisitedOutbreakAreaDE = 'Ss5EUSnztys';
  static const String exposureCareForSickDE = 'oi4fkL6lZd3';
  static const String exposureParticipateBurialDE = 'ya8XBTYJvRR';

  // declaration
  static const String declareTsfDE = 'hkbXrBQuVil';
}
