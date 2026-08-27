import '../entities/booking.dart';
import '../entities/point_of_entry.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String pointOfEntry,
    required String arrivalDate,
    required String arrivalTime,
    String? flightNumber,
  });

  Future<Booking> getBooking(String bookingId);

  Future<List<Booking>> getBookingHistory();

  Future<Booking> updateBooking({
    required String bookingId,
    String? pointOfEntry,
    String? arrivalDate,
    String? arrivalTime,
    String? flightNumber,
  });

  Future<void> cancelBooking(String bookingId);

  Future<List<PointOfEntry>> getPointsOfEntry();
}