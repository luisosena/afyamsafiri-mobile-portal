import '../models/booking_request.dart';
import '../models/booking_response.dart';
import '../models/point_of_entry.dart';

class BookingMockDataSource {
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'bk-001',
      'referenceCode': 'AMS-2026-001',
      'pointOfEntry': 'Julius Nyerere International Airport',
      'arrivalDate': '2026-09-01',
      'arrivalTime': '14:30',
      'flightNumber': 'KQ480',
      'status': 'confirmed',
      'qrCodeData': 'AMS-2026-001-VALID-QR',
      'createdAt': '2026-08-20T10:00:00Z',
      'updatedAt': '2026-08-20T10:00:00Z',
      'userId': 'mock-user-001',
    },
    {
      'id': 'bk-002',
      'referenceCode': 'AMS-2026-002',
      'pointOfEntry': 'Kilimanjaro International Airport',
      'arrivalDate': '2026-09-15',
      'arrivalTime': '09:00',
      'flightNumber': 'ET815',
      'status': 'pending',
      'createdAt': '2026-08-22T08:00:00Z',
      'updatedAt': '2026-08-22T08:00:00Z',
      'userId': 'mock-user-001',
    },
  ];

  Future<BookingResponse> createBooking(BookingRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final booking = {
      'id': 'bk-${DateTime.now().millisecondsSinceEpoch}',
      'referenceCode': 'AMS-2026-${DateTime.now().millisecondsSinceEpoch}',
      'pointOfEntry': request.pointOfEntry,
      'arrivalDate': request.arrivalDate,
      'arrivalTime': request.arrivalTime,
      'flightNumber': request.flightNumber,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'userId': 'mock-user-001',
    };

    _bookings.add(booking);
    return BookingResponse.fromJson(booking);
  }

  Future<BookingResponse> getBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final booking = _bookings.firstWhere(
      (b) => b['id'] == bookingId,
      orElse: () => throw Exception('Booking not found'),
    );

    return BookingResponse.fromJson(booking);
  }

  Future<List<BookingResponse>> getBookingHistory() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return _bookings
        .map((b) => BookingResponse.fromJson(b))
        .toList();
  }

  Future<BookingResponse> updateBooking({
    required String bookingId,
    String? pointOfEntry,
    String? arrivalDate,
    String? arrivalTime,
    String? flightNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final index = _bookings.indexWhere((b) => b['id'] == bookingId);
    if (index == -1) throw Exception('Booking not found');

    if (pointOfEntry != null) _bookings[index]['pointOfEntry'] = pointOfEntry;
    if (arrivalDate != null) _bookings[index]['arrivalDate'] = arrivalDate;
    if (arrivalTime != null) _bookings[index]['arrivalTime'] = arrivalTime;
    if (flightNumber != null) _bookings[index]['flightNumber'] = flightNumber;
    _bookings[index]['updatedAt'] = DateTime.now().toIso8601String();

    return BookingResponse.fromJson(_bookings[index]);
  }

  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(seconds: 1));

    final index = _bookings.indexWhere((b) => b['id'] == bookingId);
    if (index == -1) throw Exception('Booking not found');

    _bookings[index]['status'] = 'cancelled';
    _bookings[index]['updatedAt'] = DateTime.now().toIso8601String();
  }

  Future<List<PointOfEntryModel>> getPointsOfEntry() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const PointOfEntryModel(
        id: 'poe-001',
        name: 'Julius Nyerere International Airport',
        type: 'airport',
        location: 'Dar es Salaam',
      ),
      const PointOfEntryModel(
        id: 'poe-002',
        name: 'Kilimanjaro International Airport',
        type: 'airport',
        location: 'Kilimanjaro',
      ),
      const PointOfEntryModel(
        id: 'poe-003',
        name: 'Namanga Border Post',
        type: 'land',
        location: 'Arusha',
      ),
      const PointOfEntryModel(
        id: 'poe-004',
        name: 'Tunduma Border Post',
        type: 'land',
        location: 'Mbeya',
      ),
      const PointOfEntryModel(
        id: 'poe-005',
        name: 'Dar es Salaam Port',
        type: 'marine',
        location: 'Dar es Salaam',
      ),
    ];
  }
}