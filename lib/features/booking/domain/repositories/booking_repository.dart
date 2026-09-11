import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Booking> submitBooking(Booking booking);

  Future<List<Booking>> getBookings();

  Future<void> cancelBooking(String bookingId);

  Future<List<String>> getPortsOfEntry();

  Future<List<String>> getNationalities();

  Future<List<String>> getCountries();

  Future<List<String>> getPurposesOfVisit();
}