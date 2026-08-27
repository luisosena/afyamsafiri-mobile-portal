class TravelHistory {
  const TravelHistory({
    required this.countries,
  });

  final List<String> countries;
}

class Symptom {
  const Symptom({
    required this.id,
    required this.name,
    this.selected = false,
  });

  final String id;
  final String name;
  final bool selected;
}

class VaccinationInfo {
  const VaccinationInfo({
    this.isVaccinated,
    this.certificateFilePath,
  });

  final bool? isVaccinated;
  final String? certificateFilePath;
}

class AdditionalHealthInfo {
  const AdditionalHealthInfo({
    this.hasContactWithInfectiousDisease,
    this.isMedicalTravelPurpose,
  });

  final bool? hasContactWithInfectiousDisease;
  final bool? isMedicalTravelPurpose;
}

class Screening {
  const Screening({
    this.travelHistory,
    this.symptoms,
    this.vaccinationInfo,
    this.additionalHealthInfo,
    this.declarationAccepted = false,
    this.isDraft = false,
  });

  final TravelHistory? travelHistory;
  final List<Symptom>? symptoms;
  final VaccinationInfo? vaccinationInfo;
  final AdditionalHealthInfo? additionalHealthInfo;
  final bool declarationAccepted;
  final bool isDraft;
}