import '../models/booking_request.dart';
import '../models/booking_response.dart';
import '../models/point_of_entry.dart';

class BookingRemoteDataSource {
  Future<BookingResponse> createBooking(BookingRequest request) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<BookingResponse> getBooking(String bookingId) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<List<BookingResponse>> getBookingHistory() async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<BookingResponse> updateBooking({
    required String bookingId,
    String? pointOfEntry,
    String? arrivalDate,
    String? arrivalTime,
    String? flightNumber,
  }) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<void> cancelBooking(String bookingId) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<List<PointOfEntryModel>> getPointsOfEntry() async {
    throw UnimplementedError('Remote API not yet available');
  }
}