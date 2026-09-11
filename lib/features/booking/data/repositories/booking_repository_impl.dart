import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_mock_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required this.remoteDataSource,
  });

  final BookingMockDataSource remoteDataSource;

  @override
  Future<Booking> submitBooking(Booking booking) async {
    final data = {
      'passportNumber': booking.passportNumber,
      'portOfEntry': booking.portOfEntry,
      'arrivalDate': booking.arrivalDate?.toIso8601String(),
      'firstName': booking.firstName,
      'middleName': booking.middleName,
      'surname': booking.surname,
      'gender': booking.gender,
      'dateOfBirth': booking.dateOfBirth?.toIso8601String(),
      'nationality': booking.nationality,
      'vesselName': booking.vesselName,
      'seatNumber': booking.seatNumber,
      'purposeOfVisit': booking.purposeOfVisit,
      'durationOfStay': booking.durationOfStay,
      'localAddress': booking.localAddress,
      'hotelName': booking.hotelName,
      'localPhone': booking.localPhone,
      'email': booking.email,
      'journeyStartCountry': booking.journeyStartCountry,
      'countriesVisitedCount': booking.countriesVisitedCount,
      'symptoms': booking.symptoms
          .where((s) => s.value == true)
          .map((s) => s.name)
          .toList(),
      'additionalSymptoms': booking.additionalSymptoms,
      'visitedOutbreakArea': booking.visitedOutbreakArea,
      'caredForSick': booking.caredForSick,
      'participatedInBurial': booking.participatedInBurial,
    };

    final response = await remoteDataSource.submitBooking(data);

    return booking.copyWith(
      id: response['id'] as String?,
      referenceCode: response['referenceCode'] as String?,
      status: BookingStatus.submitted,
      createdAt: DateTime.tryParse(response['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(response['updatedAt'] as String? ?? ''),
    );
  }

  @override
  Future<List<String>> getPortsOfEntry() => remoteDataSource.getPortsOfEntry();

  @override
  Future<List<String>> getNationalities() => remoteDataSource.getNationalities();

  @override
  Future<List<String>> getCountries() => remoteDataSource.getCountries();

  @override
  Future<List<String>> getPurposesOfVisit() => remoteDataSource.getPurposesOfVisit();

  @override
  Future<List<Booking>> getBookings() async {
    final responses = await remoteDataSource.getBookings();
    return responses.map((r) {
      return Booking(
        id: r['id'] as String?,
        referenceCode: r['referenceCode'] as String?,
        status: r['status'] == 'submitted'
            ? BookingStatus.submitted
            : r['status'] == 'cancelled'
                ? BookingStatus.cancelled
                : BookingStatus.draft,
        passportNumber: r['passportNumber'] as String? ?? '',
        portOfEntry: r['portOfEntry'] as String? ?? '',
        arrivalDate: r['arrivalDate'] != null
            ? DateTime.tryParse(r['arrivalDate'] as String)
            : null,
        firstName: r['firstName'] as String? ?? '',
        surname: r['surname'] as String? ?? '',
        gender: r['gender'] as String? ?? '',
        nationality: r['nationality'] as String? ?? '',
        vesselName: r['vesselName'] as String? ?? '',
        purposeOfVisit: r['purposeOfVisit'] as String? ?? '',
        createdAt: r['createdAt'] != null
            ? DateTime.tryParse(r['createdAt'] as String)
            : null,
      );
    }).toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await remoteDataSource.cancelBooking(bookingId);
  }
}