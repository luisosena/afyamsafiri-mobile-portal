import '../../domain/entities/screening.dart';
import '../../domain/repositories/screening_repository.dart';
import '../datasources/screening_mock_datasource.dart';
import '../models/screening_request.dart';

class ScreeningRepositoryImpl implements ScreeningRepository {
  ScreeningRepositoryImpl({
    required this.remoteDataSource,
  });

  final ScreeningMockDataSource remoteDataSource;

  @override
  Future<void> submitScreening({
    required String bookingId,
    required Screening screening,
  }) async {
    final request = _screeningToRequest(bookingId, screening);
    await remoteDataSource.submitScreening(request);
  }

  @override
  Future<Screening?> getScreening(String bookingId) async {
    final data = await remoteDataSource.getScreening(bookingId);
    if (data == null) return null;
    return _screeningFromMap(data);
  }

  @override
  Future<void> saveDraft({
    required String bookingId,
    required Screening screening,
  }) async {
    final request = _screeningToRequest(bookingId, screening);
    await remoteDataSource.saveDraft(bookingId, request);
  }

  @override
  Future<Screening?> getDraft(String bookingId) async {
    final data = await remoteDataSource.getDraft(bookingId);
    if (data == null) return null;
    return _screeningFromMap(data);
  }

  ScreeningRequest _screeningToRequest(String bookingId, Screening s) {
    return ScreeningRequest(
      bookingId: bookingId,
      countriesVisited: s.travelHistory?.countries,
      symptoms: s.symptoms?.where((s) => s.selected).map((s) => s.name).toList(),
      isVaccinated: s.vaccinationInfo?.isVaccinated,
      certificateFilePath: s.vaccinationInfo?.certificateFilePath,
      hasContactWithInfectiousDisease: s.additionalHealthInfo?.hasContactWithInfectiousDisease,
      isMedicalTravelPurpose: s.additionalHealthInfo?.isMedicalTravelPurpose,
      declarationAccepted: s.declarationAccepted,
    );
  }

  Screening _screeningFromMap(Map<String, dynamic> data) {
    return Screening(
      travelHistory: data['countriesVisited'] != null
          ? TravelHistory(countries: List<String>.from(data['countriesVisited'] as List))
          : null,
      vaccinationInfo: VaccinationInfo(
        isVaccinated: data['isVaccinated'] as bool?,
        certificateFilePath: data['certificateFilePath'] as String?,
      ),
      additionalHealthInfo: AdditionalHealthInfo(
        hasContactWithInfectiousDisease: data['hasContactWithInfectiousDisease'] as bool?,
        isMedicalTravelPurpose: data['isMedicalTravelPurpose'] as bool?,
      ),
      declarationAccepted: data['declarationAccepted'] as bool? ?? false,
    );
  }
}