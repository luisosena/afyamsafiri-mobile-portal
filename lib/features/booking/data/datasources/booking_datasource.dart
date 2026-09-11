abstract class BookingDataSource {
  Future<Map<String, dynamic>> submitBooking(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getBookings();
  Future<void> cancelBooking(String bookingId);
  Future<List<String>> getPortsOfEntry();
  Future<List<String>> getNationalities();
  Future<List<String>> getCountries();
  Future<List<String>> getPurposesOfVisit();
}
