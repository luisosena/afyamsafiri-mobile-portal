class ScreeningRequest {
  const ScreeningRequest({
    required this.bookingId,
    this.countriesVisited,
    this.symptoms,
    this.isVaccinated,
    this.certificateFilePath,
    this.hasContactWithInfectiousDisease,
    this.isMedicalTravelPurpose,
    this.declarationAccepted = false,
  });

  final String bookingId;
  final List<String>? countriesVisited;
  final List<String>? symptoms;
  final bool? isVaccinated;
  final String? certificateFilePath;
  final bool? hasContactWithInfectiousDisease;
  final bool? isMedicalTravelPurpose;
  final bool declarationAccepted;

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        if (countriesVisited != null) 'countriesVisited': countriesVisited,
        if (symptoms != null) 'symptoms': symptoms,
        if (isVaccinated != null) 'isVaccinated': isVaccinated,
        if (certificateFilePath != null) 'certificateFilePath': certificateFilePath,
        if (hasContactWithInfectiousDisease != null)
          'hasContactWithInfectiousDisease': hasContactWithInfectiousDisease,
        if (isMedicalTravelPurpose != null)
          'isMedicalTravelPurpose': isMedicalTravelPurpose,
        'declarationAccepted': declarationAccepted,
      };
}