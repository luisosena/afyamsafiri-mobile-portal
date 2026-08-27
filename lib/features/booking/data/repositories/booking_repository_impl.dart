import '../../domain/entities/booking.dart';
import '../../domain/entities/point_of_entry.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_mock_datasource.dart';
import '../models/booking_request.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required this.remoteDataSource,
  });

  final BookingMockDataSource remoteDataSource;

  @override
  Future<Booking> createBooking({
    required String pointOfEntry,
    required String arrivalDate,
    required String arrivalTime,
    String? flightNumber,
  }) async {
    final request = BookingRequest(
      pointOfEntry: pointOfEntry,
      arrivalDate: arrivalDate,
      arrivalTime: arrivalTime,
      flightNumber: flightNumber,
    );

    final response = await remoteDataSource.createBooking(request);
    return response.toEntity();
  }

  @override
  Future<Booking> getBooking(String bookingId) async {
    final response = await remoteDataSource.getBooking(bookingId);
    return response.toEntity();
  }

  @override
  Future<List<Booking>> getBookingHistory() async {
    final responses = await remoteDataSource.getBookingHistory();
    return responses.map((r) => r.toEntity()).toList();
  }

  @override
  Future<Booking> updateBooking({
    required String bookingId,
    String? pointOfEntry,
    String? arrivalDate,
    String? arrivalTime,
    String? flightNumber,
  }) async {
    final response = await remoteDataSource.updateBooking(
      bookingId: bookingId,
      pointOfEntry: pointOfEntry,
      arrivalDate: arrivalDate,
      arrivalTime: arrivalTime,
      flightNumber: flightNumber,
    );
    return response.toEntity();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await remoteDataSource.cancelBooking(bookingId);
  }

  @override
  Future<List<PointOfEntry>> getPointsOfEntry() async {
    final models = await remoteDataSource.getPointsOfEntry();
    return models.map((m) => m.toEntity()).toList();
  }
}